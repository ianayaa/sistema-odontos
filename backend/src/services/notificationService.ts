import twilio from 'twilio';
import axios from 'axios';

const accountSid = process.env.TWILIO_ACCOUNT_SID!;
const authToken = process.env.TWILIO_AUTH_TOKEN!;
const twilioPhone = process.env.TWILIO_PHONE_NUMBER!;
const twilioWhatsApp = process.env.TWILIO_WHATSAPP_NUMBER!;

const client = twilio(accountSid, authToken);

interface NotificationOptions {
  type: 'SMS' | 'WHATSAPP';
  to: string;
  message: string;
}

// Normaliza el número de teléfono al formato internacional E.164 (soporta cualquier país)
function normalizePhoneNumber(phone: string): string {
  // Elimina todos los caracteres que no sean dígitos
  let cleaned = phone.replace(/\D/g, '');
  // Si ya empieza con + y el resto son dígitos, está en formato internacional
  if (phone.startsWith('+') && /^\+\d{11,15}$/.test(phone)) return phone;
  // Si es un número local de México (10 dígitos), agrega +52
  if (/^\d{10}$/.test(cleaned)) return '+52' + cleaned;
  // Si es un número internacional (11-15 dígitos), agrega +
  if (/^\d{11,15}$/.test(cleaned)) return '+' + cleaned;
  // Si no, lanza un error claro
  throw new Error(`Número de teléfono inválido: ${phone}. Debe ser de 10 dígitos (México) o formato internacional E.164.`);
}

export const sendNotification = async (options: NotificationOptions) => {
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
    } else if (options.type === 'WHATSAPP') {
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
  } catch (error) {
    console.error(`Error al enviar ${options.type}:`, error);
    throw error;
  }
};

export const sendAppointmentReminder = async (appointment: any & { patient: { phone: string, name: string }, user?: { name?: string } }) => {
  const { patient, date, endDate, duration, user } = appointment;
  const fecha = new Date(date).toLocaleDateString('es-MX', { year: 'numeric', month: 'short', day: 'numeric' });
  const hora = new Date(date).toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' });
  const nombrePaciente = patient.name || 'Paciente';
  const nombreDoctor = user?.name || 'Tu dentista';
  const duracion = duration ? `${duration} min` : endDate ? `${Math.round((new Date(endDate).getTime() - new Date(date).getTime())/60000)} min` : '---';
  const direccion = 'Av. Manuel Lepe Macedo 208, Plaza Kobá, Local 17 Planta Baja, Guadalupe Victoria, 48317 Puerto Vallarta, Jal.';

  // Enlace largo
  const enlaceLargo = `https://odontosdentaloffice.com/confirmar-cita/${appointment.id}`;
  // Obtener enlace corto
  let enlaceConfirmacion = enlaceLargo;
  try {
    const res = await axios.post(`${process.env.SHORTENER_API_URL || 'http://localhost:3000/api/shortener'}`, { url: enlaceLargo });
    enlaceConfirmacion = res.data.short;
  } catch (e) {
    // Si falla, usa el largo
  }
  const mensajeSMS = `Odontos Dental Office: ${nombrePaciente}, tu cita es el ${fecha} ${hora}. Confirma: ${enlaceConfirmacion}`;
  console.log('Preparando SMS:', mensajeSMS);
  await sendNotification({
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

export const sendPaymentReminder = async (payment: any & { patient: { phone: string } }) => {
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

export async function sendSMS(to: string, message: string) {
  return client.messages.create({
    body: message,
    from: twilioPhone,
    to
  });
}

export async function sendWhatsApp(to: string, message: string) {
  return client.messages.create({
    body: message,
    from: twilioWhatsApp,
    to: `whatsapp:${to}`
  });
} 