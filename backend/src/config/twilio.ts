import twilio from 'twilio';

const accountSid = process.env.TWILIO_ACCOUNT_SID!;
const authToken = process.env.TWILIO_AUTH_TOKEN!;
const twilioPhone = process.env.TWILIO_PHONE_NUMBER!;
const twilioWhatsApp = process.env.TWILIO_WHATSAPP_NUMBER!;

// Configuración de plantillas de WhatsApp
export const whatsappTemplates = {
  appointment: {
    sid: 'HXb04649447daa754fa0a419861cf1bc87'
  }
};

const client = twilio(accountSid, authToken);

export { client, twilioPhone, twilioWhatsApp }; 