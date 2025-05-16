"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.twilioWhatsApp = exports.twilioPhone = exports.client = exports.whatsappTemplates = void 0;
const twilio_1 = __importDefault(require("twilio"));
const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const twilioPhone = process.env.TWILIO_PHONE_NUMBER;
exports.twilioPhone = twilioPhone;
const twilioWhatsApp = process.env.TWILIO_WHATSAPP_NUMBER;
exports.twilioWhatsApp = twilioWhatsApp;
// Configuración de plantillas de WhatsApp
exports.whatsappTemplates = {
    appointment: {
        sid: 'HXb04649447daa754fa0a419861cf1bc87'
    }
};
const client = (0, twilio_1.default)(accountSid, authToken);
exports.client = client;
