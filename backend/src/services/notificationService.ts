import { client, twilioWhatsApp, whatsappTemplates } from '../config/twilio';
import axios from 'axios';

type NotificationType = 'WHATSAPP';

interface NotificationOptions {
  type: NotificationType;
  to: string;
  message: string;
}

function normalizePhoneNumber(phone: string): string {
  // Elimina todos los caracteres que no sean dígitos
  let cleaned = phone.replace(/\D/g, '');
  // Si ya empieza con + y el resto son dígitos, está en formato internacional
  if (phone.startsWith('+') && /^\+\d{11,15}$/.test(phone)) return phone;
  // Si es un número local de México (10 dígitos), agrega +52
  if (/^\d{10}$/.test(cleaned)) return '+52' + cleaned;
  // Si es un número internacional (11-15 dígitos), agrega + si no lo tiene
  if (/^\d{11,15}$/.test(cleaned)) return '+' + cleaned;
  // Si no, lanza un error claro
  throw new Error(`Número de teléfono inválido: ${phone}. Debe ser de 10 dígitos (México) o formato internacional E.164.`);
}

export const sendNotification = async (options: NotificationOptions) => {
  try {
    const normalizedTo = normalizePhoneNumber(options.to);
    console.log('Enviando notificación:', options);
    console.log('Intentando enviar WhatsApp a:', `whatsapp:${normalizedTo}`);
    const result = await client.messages.create({
      body: options.message,
      from: twilioWhatsApp,
      to: `whatsapp:${normalizedTo}`,
      persistentAction: [
        'reply:Confirmar',
        'reply:Cancelar'
      ]
    });
    console.log('Resultado WhatsApp:', result.sid);
    console.log('Notificación enviada correctamente:', options.type);
  } catch (error) {
    console.error(`Error al enviar ${options.type}:`, error);
    throw error;
  }
};

export const sendAppointmentReminder = async (appointment: any & { patient: { phone: string, name: string }, customMessage?: string, user?: { name?: string } }) => {
  const { patient, date, customMessage, id } = appointment;
  
  if (customMessage) {
    await sendNotification({
      type: 'WHATSAPP',
      to: patient.phone,
      message: customMessage
    });
    return;
  }

  const formattedDate = new Date(date).toLocaleDateString('es-MX');
  const formattedTime = new Date(date).toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' });

  try {
    const normalizedPhone = normalizePhoneNumber(patient.phone);
    await client.messages.create({
      from: twilioWhatsApp,
      to: `whatsapp:${normalizedPhone}`,
      contentSid: whatsappTemplates.appointment.sid,
      contentVariables: JSON.stringify({
        '1': id,
        '2': patient.name,
        '3': formattedDate,
        '4': formattedTime
      })
    });
  } catch (error) {
    console.error('Error al enviar recordatorio de cita:', error);
    throw error;
  }
};

export const sendBulkNotifications = async (
  patients: { phone: string }[],
  message: string,
  type: NotificationType = 'WHATSAPP'
) => {
  const notifications = patients.map(patient => ({
    type,
    to: patient.phone,
    message
  }));

  await Promise.all(notifications.map(sendNotification));
};

export const sendCampaign = async (
  patients: { phone: string }[],
  message: string,
  type: NotificationType = 'WHATSAPP'
) => {
  try {
    await sendBulkNotifications(patients, message, type);
    return { success: true, message: 'Campaña enviada exitosamente' };
  } catch (error) {
    console.error('Error al enviar campaña:', error);
    return { success: false, message: 'Error al enviar campaña' };
  }
};

export async function sendWhatsApp(to: string, message: string) {
  const normalizedTo = normalizePhoneNumber(to);
  return client.messages.create({
    body: message,
    from: twilioWhatsApp,
    to: `whatsapp:${normalizedTo}`
  });
} 