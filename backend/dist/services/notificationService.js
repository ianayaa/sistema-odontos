"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendWhatsApp = exports.sendCampaign = exports.sendBulkNotifications = exports.sendAppointmentReminder = exports.sendNotification = void 0;
const twilio_1 = require("../config/twilio");
const date_fns_tz_1 = require("date-fns-tz");
// Constantes
const TIMEZONE = 'America/Mexico_City';
const DATE_FORMAT = 'dd/MM/yyyy';
const TIME_FORMAT = 'HH:mm';
// Funciones de utilidad
function normalizePhoneNumber(phone) {
    const cleaned = phone.replace(/\D/g, '');
    if (phone.startsWith('+') && /^\+\d{11,15}$/.test(phone)) {
        return phone;
    }
    if (/^\d{10}$/.test(cleaned)) {
        return '+52' + cleaned;
    }
    if (/^\d{11,15}$/.test(cleaned)) {
        return '+' + cleaned;
    }
    throw new Error(`Número de teléfono inválido: ${phone}. Debe ser de 10 dígitos (México) o formato internacional E.164.`);
}
function formatAppointmentDateTime(date) {
    return {
        formattedDate: (0, date_fns_tz_1.formatInTimeZone)(date, TIMEZONE, DATE_FORMAT),
        formattedTime: (0, date_fns_tz_1.formatInTimeZone)(date, TIMEZONE, TIME_FORMAT)
    };
}
// Funciones principales
const sendNotification = async (options) => {
    try {
        const normalizedTo = normalizePhoneNumber(options.to);
        console.log('Enviando notificación:', options);
        console.log('Intentando enviar WhatsApp a:', `whatsapp:${normalizedTo}`);
        const result = await twilio_1.client.messages.create({
            body: options.message,
            from: twilio_1.twilioWhatsApp,
            to: `whatsapp:${normalizedTo}`,
            persistentAction: [
                'reply:Confirmar',
                'reply:Cancelar'
            ]
        });
        console.log('Resultado WhatsApp:', result.sid);
        console.log('Notificación enviada correctamente:', options.type);
    }
    catch (error) {
        const notificationError = new Error(`Error al enviar ${options.type}`);
        notificationError.code = 'NOTIFICATION_ERROR';
        notificationError.details = error;
        throw notificationError;
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
    const appointmentDate = new Date(date);
    const { formattedDate, formattedTime } = formatAppointmentDateTime(appointmentDate);
    console.log('Fecha de la cita:', {
        original: date,
        local: appointmentDate.toLocaleString(),
        formatted: `${formattedDate} ${formattedTime}`,
        timezone: TIMEZONE
    });
    try {
        const normalizedPhone = normalizePhoneNumber(patient.phone);
        await twilio_1.client.messages.create({
            from: twilio_1.twilioWhatsApp,
            to: `whatsapp:${normalizedPhone}`,
            contentSid: twilio_1.whatsappTemplates.appointment.sid,
            contentVariables: JSON.stringify({
                '1': patient.name,
                '2': formattedDate,
                '3': formattedTime
            })
        });
    }
    catch (error) {
        const notificationError = new Error('Error al enviar recordatorio de cita');
        notificationError.code = 'APPOINTMENT_REMINDER_ERROR';
        notificationError.details = error;
        throw notificationError;
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
const sendWhatsApp = async (to, message) => {
    const normalizedTo = normalizePhoneNumber(to);
    return twilio_1.client.messages.create({
        body: message,
        from: twilio_1.twilioWhatsApp,
        to: `whatsapp:${normalizedTo}`
    });
};
exports.sendWhatsApp = sendWhatsApp;
