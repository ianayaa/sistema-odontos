import twilio from 'twilio';
import { Appointment, Payment } from '@prisma/client';

const twilioClient = twilio(
  process.env.TWILIO_ACCOUNT_SID,
  process.env.TWILIO_AUTH_TOKEN
);

interface NotificationOptions {
  type: 'SMS' | 'WHATSAPP';
  to: string;
  message: string;
}

export const sendNotification = async (options: NotificationOptions) => {
  try {
    if (options.type === 'SMS') {
      await twilioClient.messages.create({
        body: options.message,
        from: process.env.TWILIO_PHONE_NUMBER,
        to: options.to
      });
    } else if (options.type === 'WHATSAPP') {
      // TODO: Implementar envío de WhatsApp cuando tengamos las credenciales
      console.log('Envío de WhatsApp no implementado aún');
    }
  } catch (error) {
    console.error(`Error al enviar ${options.type}:`, error);
    throw error;
  }
};

export const sendAppointmentReminder = async (appointment: Appointment & { patient: { phone: string } }) => {
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

  await sendNotification({
    type: 'SMS',
    to: patient.phone,
    message
  });
};

export const sendPaymentReminder = async (payment: Payment & { patient: { phone: string } }) => {
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

  await sendNotification({
    type: 'SMS',
    to: patient.phone,
    message
  });
};

export const sendBulkNotifications = async (
  patients: { phone: string }[],
  message: string,
  type: 'SMS' | 'WHATSAPP' = 'SMS'
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
  type: 'SMS' | 'WHATSAPP' = 'SMS'
) => {
  try {
    await sendBulkNotifications(patients, message, type);
    return { success: true, message: 'Campaña enviada exitosamente' };
  } catch (error) {
    console.error('Error al enviar campaña:', error);
    return { success: false, message: 'Error al enviar campaña' };
  }
}; 