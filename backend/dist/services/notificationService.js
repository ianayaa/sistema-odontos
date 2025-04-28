"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendCampaign = exports.sendBulkNotifications = exports.sendPaymentReminder = exports.sendAppointmentReminder = exports.sendNotification = void 0;
const twilio_1 = __importDefault(require("twilio"));
const twilioClient = (0, twilio_1.default)(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);
const sendNotification = async (options) => {
    try {
        if (options.type === 'SMS') {
            await twilioClient.messages.create({
                body: options.message,
                from: process.env.TWILIO_PHONE_NUMBER,
                to: options.to
            });
        }
        else if (options.type === 'WHATSAPP') {
            // TODO: Implementar envío de WhatsApp cuando tengamos las credenciales
            console.log('Envío de WhatsApp no implementado aún');
        }
    }
    catch (error) {
        console.error(`Error al enviar ${options.type}:`, error);
        throw error;
    }
};
exports.sendNotification = sendNotification;
const sendAppointmentReminder = async (appointment) => {
    const { patient, date, status } = appointment;
    const formattedDate = new Date(date).toLocaleString('es-MX', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
    let message = '';
    switch (status) {
        case 'SCHEDULED':
            message = `Hola, tienes una cita programada para el ${formattedDate}. Por favor confirma tu asistencia.`;
            break;
        case 'CONFIRMED':
            message = `Tu cita para el ${formattedDate} ha sido confirmada. ¡Te esperamos!`;
            break;
        case 'CANCELLED':
            message = `Tu cita para el ${formattedDate} ha sido cancelada.`;
            break;
        case 'COMPLETED':
            message = `Gracias por asistir a tu cita del ${formattedDate}.`;
            break;
    }
    await (0, exports.sendNotification)({
        type: 'SMS',
        to: patient.phone,
        message
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
