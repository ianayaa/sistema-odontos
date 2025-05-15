"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendCampaign = exports.sendBulkNotifications = exports.sendAppointmentReminder = exports.sendNotification = void 0;
exports.sendWhatsApp = sendWhatsApp;
const twilio_1 = require("../config/twilio");
const sendNotification = async (options) => {
    try {
        console.log('Enviando notificación:', options);
        console.log('Intentando enviar WhatsApp a:', `whatsapp:${options.to}`);
        const result = await twilio_1.client.messages.create({
            body: options.message,
            from: twilio_1.twilioWhatsApp,
            to: `whatsapp:${options.to}`,
            persistentAction: [
                'reply:Confirmar',
                'reply:Cancelar'
            ]
        });
        console.log('Resultado WhatsApp:', result.sid);
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
    if (customMessage) {
        await (0, exports.sendNotification)({
            type: 'WHATSAPP',
            to: patient.phone,
            message: customMessage
        });
        return;
    }
    const formattedDate = new Date(date).toLocaleDateString('es-MX');
    const formattedTime = new Date(date).toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' });
    try {
        await twilio_1.client.messages.create({
            from: twilio_1.twilioWhatsApp,
            to: `whatsapp:${patient.phone}`,
            contentSid: twilio_1.whatsappTemplates.appointment.sid,
            contentVariables: JSON.stringify({
                '1': patient.name,
                '2': formattedDate,
                '3': formattedTime
            })
        });
    }
    catch (error) {
        console.error('Error al enviar recordatorio de cita:', error);
        throw error;
    }
};
exports.sendAppointmentReminder = sendAppointmentReminder;
const sendBulkNotifications = async (patients, message, type = 'WHATSAPP') => {
    const notifications = patients.map(patient => ({
        type,
        to: patient.phone,
        message
    }));
    await Promise.all(notifications.map(exports.sendNotification));
};
exports.sendBulkNotifications = sendBulkNotifications;
const sendCampaign = async (patients, message, type = 'WHATSAPP') => {
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
async function sendWhatsApp(to, message) {
    return twilio_1.client.messages.create({
        body: message,
        from: twilio_1.twilioWhatsApp,
        to: `whatsapp:${to}`
    });
}
