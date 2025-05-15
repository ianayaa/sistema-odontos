import { client, twilioWhatsApp, whatsappTemplates } from '../config/twilio';
import axios from 'axios';

type NotificationType = 'WHATSAPP';

interface NotificationOptions {
  type: NotificationType;
  to: string;
  message: string;
}

export const sendNotification = async (options: NotificationOptions) => {
  try {
    console.log('Enviando notificación:', options);
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
    console.log('Notificación enviada correctamente:', options.type);
  } catch (error) {
    console.error(`Error al enviar ${options.type}:`, error);
    throw error;
  }
};

export const sendAppointmentReminder = async (appointment: any & { patient: { phone: string, name: string }, customMessage?: string, user?: { name?: string } }) => {
  const { patient, date, customMessage } = appointment;
  
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
    await client.messages.create({
      from: twilioWhatsApp,
      to: `whatsapp:${patient.phone}`,
      contentSid: whatsappTemplates.appointment.sid,
      contentVariables: JSON.stringify({
        '1': patient.name,
        '2': formattedDate,
        '3': formattedTime
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
  return client.messages.create({
    body: message,
    from: twilioWhatsApp,
    to: `whatsapp:${to}`
  });
} 