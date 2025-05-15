import twilio from 'twilio';

const accountSid = process.env.TWILIO_ACCOUNT_SID!;
const authToken = process.env.TWILIO_AUTH_TOKEN!;
const twilioPhone = process.env.TWILIO_PHONE_NUMBER!;
const twilioWhatsApp = process.env.TWILIO_WHATSAPP_NUMBER!;

// Configuración de plantillas de WhatsApp
export const whatsappTemplates = {
  appointment: {
    sid: 'HX5574f13fad9b6399dc853eccee60b5b4', // SID real de la plantilla
    variables: ['nombrePaciente', 'fecha', 'hora']
  }
};

const client = twilio(accountSid, authToken);

export { client, twilioPhone, twilioWhatsApp }; 