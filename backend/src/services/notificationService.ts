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
    console.log('Enviando notificación:', options);
    if (options.type === 'SMS') {
      const result = await twilioClient.messages.create({
        body: options.message,
        from: process.env.TWILIO_PHONE_NUMBER,
        to: options.to
      });
      console.log('Resultado SMS:', result.sid);
    } else if (options.type === 'WHATSAPP') {
      console.log('Intentando enviar WhatsApp a:', `whatsapp:${options.to}`);
      const result = await twilioClient.messages.create({
        body: options.message,
        from: process.env.TWILIO_WHATSAPP_NUMBER,
        to: `whatsapp:${options.to}`,
        persistentAction: [
          'reply:Confirmar',
          'reply:Cancelar'
        ]
      });
      console.log('Resultado WhatsApp:', result.sid);
    }
    console.log('Notificación enviada correctamente:', options.type);
  } catch (error) {
    console.error(`Error al enviar ${options.type}:`, error);
    throw error;
  }
};

export const sendAppointmentReminder = async (appointment: Appointment & { patient: { phone: string, name: string } }) => {
  const { patient, date } = appointment;
  const fecha = new Date(date).toLocaleDateString('es-MX', { year: 'numeric', month: 'long', day: 'numeric' });
  const hora = new Date(date).toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' });
  const nombrePaciente = patient.name || 'Paciente';

  // Mensaje bonito para WhatsApp
  const mensajeWhatsApp = `Odontos Dental Office\n\nHola ${nombrePaciente}, tu cita ha sido agendada exitosamente.\n\n📅 Fecha: ${fecha}\n🕘 Hora: ${hora}\n📍 Dirección: Av. Manuel Lepe Macedo 208, Plaza Kobá, Local 17 Planta Baja, Guadalupe Victoria, 48317 Puerto Vallarta, Jal.\n\n✅ Por favor, responde a este mensaje para confirmar tu asistencia.\nTe pedimos llegar 10 minutos antes de tu cita.\n\n❗ Si necesitas cambiar o cancelar tu cita, contáctanos aquí mismo.\n\n¡Gracias por confiar en Odontos Dental Office!`;

  // Mensaje plano para SMS (acortado para Twilio trial)
  const mensajeSMS = `Odontos: ${nombrePaciente}, cita ${fecha} ${hora}. Responde OK para confirmar.`;

  console.log('Preparando SMS:', mensajeSMS);
  await sendNotification({
    type: 'SMS',
    to: patient.phone,
    message: mensajeSMS
  });
  console.log('SMS enviado, preparando WhatsApp:', mensajeWhatsApp);
  await sendNotification({
    type: 'WHATSAPP',
    to: patient.phone,
    message: mensajeWhatsApp
  });
  console.log('WhatsApp enviado');
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