"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendCampaign = exports.sendBulkNotifications = exports.sendPaymentReminder = exports.sendAppointmentReminder = exports.sendNotification = void 0;
exports.sendSMS = sendSMS;
exports.sendWhatsApp = sendWhatsApp;
const twilio_1 = __importDefault(require("twilio"));
const axios_1 = __importDefault(require("axios"));
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
    const { patient, date, endDate, duration, user } = appointment;
    const fecha = new Date(date).toLocaleDateString('es-MX', { year: 'numeric', month: 'short', day: 'numeric' });
    const hora = new Date(date).toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' });
    const nombrePaciente = patient.name || 'Paciente';
    const nombreDoctor = user?.name || 'Tu dentista';
    const duracion = duration ? `${duration} min` : endDate ? `${Math.round((new Date(endDate).getTime() - new Date(date).getTime()) / 60000)} min` : '---';
    const direccion = 'Av. Manuel Lepe Macedo 208, Plaza Kobá, Local 17 Planta Baja, Guadalupe Victoria, 48317 Puerto Vallarta, Jal.';
    // Enlace largo
    const enlaceLargo = `https://odontosdentaloffice.com/confirmar-cita/${appointment.id}`;
    // Obtener enlace corto
    let enlaceConfirmacion = enlaceLargo;
    try {
        const res = await axios_1.default.post(`${process.env.SHORTENER_API_URL || 'http://localhost:3000/api/shortener'}`, { url: enlaceLargo });
        enlaceConfirmacion = res.data.short;
    }
    catch (e) {
        // Si falla, usa el largo
    }
    const mensajeSMS = `Odontos Dental Office: ${nombrePaciente}, tu cita es el ${fecha} ${hora}. Confirma: ${enlaceConfirmacion}`;
    console.log('Preparando SMS:', mensajeSMS);
    await (0, exports.sendNotification)({
        type: 'SMS',
        to: patient.phone,
        message: mensajeSMS
    });
    // WhatsApp desactivado temporalmente
    // await sendNotification({
    //   type: 'WHATSAPP',
    //   to: patient.phone,
    //   message: mensajeWhatsApp
    // });
    // console.log('WhatsApp enviado');
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
