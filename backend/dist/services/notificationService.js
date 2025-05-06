"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendCampaign = exports.sendBulkNotifications = exports.sendPaymentReminder = exports.sendAppointmentReminder = exports.sendNotification = void 0;
exports.sendSMS = sendSMS;
exports.sendWhatsApp = sendWhatsApp;
const twilio_1 = __importDefault(require("twilio"));
const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const twilioPhone = process.env.TWILIO_PHONE_NUMBER;
const twilioWhatsApp = process.env.TWILIO_WHATSAPP_NUMBER;
const client = (0, twilio_1.default)(accountSid, authToken);
// Normaliza el número de teléfono al formato internacional E.164 (soporta cualquier país)
function normalizePhoneNumber(phone) {
    // Elimina todos los caracteres que no sean dígitos
    let cleaned = phone.replace(/\D/g, '');
    // Si ya empieza con + y el resto son dígitos, está en formato internacional
    if (phone.startsWith('+') && /^\+\d{11,15}$/.test(phone))
        return phone;
    // Si es un número local de México (10 dígitos), agrega +52
    if (/^\d{10}$/.test(cleaned))
        return '+52' + cleaned;
    // Si es un número internacional (11-15 dígitos), agrega +
    if (/^\d{11,15}$/.test(cleaned))
        return '+' + cleaned;
    // Si no, lanza un error claro
    throw new Error(`Número de teléfono inválido: ${phone}. Debe ser de 10 dígitos (México) o formato internacional E.164.`);
}
const sendNotification = async (options) => {
    try {
        console.log('Enviando notificación:', options);
        if (options.type === 'SMS') {
            const to = normalizePhoneNumber(options.to);
            const result = await client.messages.create({
                body: options.message,
                from: twilioPhone,
                to
            });
            console.log('Resultado SMS:', result.sid);
        }
        else if (options.type === 'WHATSAPP') {
            console.log('Intentando enviar WhatsApp a:', `whatsapp:${options.to}`);
            const result = await client.messages.create({
                body: options.message,
                from: twilioWhatsApp,
                to: `whatsapp:${options.to}`,
                persistentAction: [
                    'reply:Confirmar',
                    'reply:Cancelar'
                ]
            });
            console.log('Resultado WhatsApp:', result.sid);
        }
        console.log('Notificación enviada correctamente:', options.type);
    }
    catch (error) {
        console.error(`Error al enviar ${options.type}:`, error);
        throw error;
    }
};
exports.sendNotification = sendNotification;
const sendAppointmentReminder = async (appointment) => {
    const { patient, date, customMessage } = appointment;
    let mensajeSMS = customMessage;
    if (!mensajeSMS) {
        // Mensaje mínimo para nueva cita
        mensajeSMS = `Odontos: ${patient.name}, tu cita es el ${new Date(date).toLocaleDateString('es-MX')} a las ${new Date(date).toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' })}.`;
    }
    console.log('Preparando SMS:', mensajeSMS);
    await (0, exports.sendNotification)({
        type: 'SMS',
        to: patient.phone,
        message: mensajeSMS
    });
};
exports.sendAppointmentReminder = sendAppointmentReminder;
const sendPaymentReminder = async (payment) => {
    const { patient, amount, status } = payment;
    const formattedAmount = new Intl.NumberFormat('es-MX', {
        style: 'currency',
        currency: 'MXN'
    }).format(amount);
    let message = '';
    switch (status) {
        case 'PENDING':
            message = `Hola, tienes un pago pendiente de ${formattedAmount}. Por favor realiza el pago lo antes posible.`;
            break;
        case 'COMPLETED':
            message = `Gracias por tu pago de ${formattedAmount}. El pago ha sido registrado exitosamente.`;
            break;
        case 'CANCELLED':
            message = `Tu pago de ${formattedAmount} ha sido cancelado.`;
            break;
    }
    await (0, exports.sendNotification)({
        type: 'SMS',
        to: patient.phone,
        message
    });
};
exports.sendPaymentReminder = sendPaymentReminder;
const sendBulkNotifications = async (patients, message, type = 'SMS') => {
    const notifications = patients.map(patient => ({
        type,
        to: patient.phone,
        message
    }));
    await Promise.all(notifications.map(exports.sendNotification));
};
exports.sendBulkNotifications = sendBulkNotifications;
const sendCampaign = async (patients, message, type = 'SMS') => {
    try {
        await (0, exports.sendBulkNotifications)(patients, message, type);
        return { success: true, message: 'Campaña enviada exitosamente' };
    }
    catch (error) {
        console.error('Error al enviar campaña:', error);
        return { success: false, message: 'Error al enviar campaña' };
    }
};
exports.sendCampaign = sendCampaign;
async function sendSMS(to, message) {
    return client.messages.create({
        body: message,
        from: twilioPhone,
        to
    });
}
async function sendWhatsApp(to, message) {
    return client.messages.create({
        body: message,
        from: twilioWhatsApp,
        to: `whatsapp:${to}`
    });
}
