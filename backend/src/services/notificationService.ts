import { client, twilioWhatsApp, whatsappTemplates } from '../config/twilio';
import axios from 'axios';
import { formatInTimeZone } from 'date-fns-tz';

// Constantes
const TIMEZONE = 'America/Mexico_City' as const;
const DATE_FORMAT = 'dd/MM/yyyy' as const;
const TIME_FORMAT = 'HH:mm' as const;

// Tipos
type NotificationType = 'WHATSAPP';

interface NotificationOptions {
  type: NotificationType;
  to: string;
  message: string;
}

interface Patient {
  phone: string;
  name: string;
}

interface User {
  name?: string;
}

interface Appointment {
  patient: Patient;
  date: Date;
  customMessage?: string;
  user?: User;
  id: string;
}

interface NotificationError extends Error {
  code?: string;
  details?: unknown;
}

// Funciones de utilidad
function normalizePhoneNumber(phone: string): string {
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

function formatAppointmentDateTime(date: Date): { formattedDate: string; formattedTime: string } {
  return {
    formattedDate: formatInTimeZone(date, TIMEZONE, DATE_FORMAT),
    formattedTime: formatInTimeZone(date, TIMEZONE, TIME_FORMAT)
  };
}

// Funciones principales
export const sendNotification = async (options: NotificationOptions): Promise<void> => {
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
    const notificationError = new Error(`Error al enviar ${options.type}`) as NotificationError;
    notificationError.code = 'NOTIFICATION_ERROR';
    notificationError.details = error;
    throw notificationError;
  }
};

export const sendAppointmentReminder = async (appointment: Appointment): Promise<void> => {
  const { patient, date, customMessage } = appointment;
  
  if (customMessage) {
    await sendNotification({
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
    await client.messages.create({
      from: twilioWhatsApp,
      to: `whatsapp:${normalizedPhone}`,
      contentSid: whatsappTemplates.appointment.sid,
      contentVariables: JSON.stringify({
        '1': patient.name,
        '2': formattedDate,
        '3': formattedTime
      })
    });
  } catch (error) {
    const notificationError = new Error('Error al enviar recordatorio de cita') as NotificationError;
    notificationError.code = 'APPOINTMENT_REMINDER_ERROR';
    notificationError.details = error;
    throw notificationError;
  }
};

export const sendBulkNotifications = async (
  patients: Pick<Patient, 'phone'>[],
  message: string,
  type: NotificationType = 'WHATSAPP'
): Promise<void> => {
  const notifications = patients.map(patient => ({
    type,
    to: patient.phone,
    message
  }));

  await Promise.all(notifications.map(sendNotification));
};

export const sendCampaign = async (
  patients: Pick<Patient, 'phone'>[],
  message: string,
  type: NotificationType = 'WHATSAPP'
): Promise<{ success: boolean; message: string }> => {
  try {
    await sendBulkNotifications(patients, message, type);
    return { success: true, message: 'Campaña enviada exitosamente' };
  } catch (error) {
    console.error('Error al enviar campaña:', error);
    return { success: false, message: 'Error al enviar campaña' };
  }
};

export const sendWhatsApp = async (to: string, message: string): Promise<any> => {
  const normalizedTo = normalizePhoneNumber(to);
  return client.messages.create({
    body: message,
    from: twilioWhatsApp,
    to: `whatsapp:${normalizedTo}`
  });
}; 