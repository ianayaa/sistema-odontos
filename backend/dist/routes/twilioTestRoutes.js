"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const notificationService_1 = require("../services/notificationService");
const twilio_1 = __importDefault(require("twilio"));
const router = express_1.default.Router();
// Función para envolver async y manejar errores correctamente en Express
function wrapAsync(fn) {
    return function (req, res, next) {
        Promise.resolve(fn(req, res, next)).catch(next);
    };
}
// Endpoint de prueba para enviar SMS o WhatsApp
router.post('/send-notification', wrapAsync(async (req, res) => {
    const { type, to, message } = req.body;
    if (!type || !to || !message) {
        return res.status(400).json({ success: false, error: 'Faltan parámetros: type, to, message' });
    }
    try {
        await (0, notificationService_1.sendNotification)({ type, to, message });
        res.json({ success: true });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : error });
    }
}));
// Endpoint para enviar mensaje de cita por WhatsApp con quick replies
router.post('/send-whatsapp-appointment', wrapAsync(async (req, res) => {
    const { to, nombrePaciente, fecha, hora } = req.body;
    if (!to || !nombrePaciente || !fecha || !hora) {
        return res.status(400).json({ success: false, error: 'Faltan parámetros: to, nombrePaciente, fecha, hora' });
    }
    const client = (0, twilio_1.default)(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);
    const body = `Odontos Dental Office\n\nHola ${nombrePaciente}, tu cita ha sido agendada exitosamente.\n\n📅 Fecha: ${fecha}\n🕘 Hora: ${hora}\n📍 Dirección: Av. Manuel Lepe Macedo 208, Plaza Kobá, Local 17 Planta Baja, Guadalupe Victoria, 48317 Puerto Vallarta, Jal.\n\n✅ Por favor, responde a este mensaje para confirmar tu asistencia.\nTe pedimos llegar 10 minutos antes de tu cita.\n\n❗ Si necesitas cambiar o cancelar tu cita, contáctanos aquí mismo.\n\n¡Gracias por confiar en Odontos Dental Office!`;
    try {
        const message = await client.messages.create({
            from: process.env.TWILIO_WHATSAPP_NUMBER,
            to: `whatsapp:${to}`,
            body,
            // persistentAction solo funciona en producción, pero lo dejamos para cuentas business
            persistentAction: [
                'reply:Confirmar',
                'reply:Cancelar'
            ]
        });
        res.json({ success: true, sid: message.sid });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : error });
    }
}));
exports.default = router;
