import twilio from 'twilio';

const accountSid = process.env.TWILIO_ACCOUNT_SID!;
const authToken = process.env.TWILIO_AUTH_TOKEN!;
const twilioPhone = process.env.TWILIO_PHONE_NUMBER!;
const twilioWhatsApp = process.env.TWILIO_WHATSAPP_NUMBER!;

// Configuración de plantillas de WhatsApp
export const whatsappTemplates = {
  appointment: {
    sid: 'HX0743dbfe93d0515d63f549ef152f7da5', // Nuevo SID de la plantilla
    variables: ['id', 'nombre', 'fecha', 'hora']
  }
};

const client = twilio(accountSid, authToken);

export { client, twilioPhone, twilioWhatsApp }; 