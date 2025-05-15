"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const twilio_1 = __importDefault(require("twilio"));
const client_1 = require("@prisma/client");
const router = express_1.default.Router();
const prisma = new client_1.PrismaClient();
// Función para envolver async y manejar errores correctamente en Express
function wrapAsync(fn) {
    return function (req, res, next) {
        Promise.resolve(fn(req, res, next)).catch(next);
    };
}
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
// Webhook para recibir respuestas de WhatsApp
router.post('/webhook', express_1.default.json(), async (req, res) => {
    // Twilio manda los datos en x-www-form-urlencoded por default
    const payload = req.body.ButtonPayload || req.body.buttonPayload || '';
    const from = req.body.From || req.body.from;
    const waId = req.body.WaId || req.body.waId;
    console.log('Webhook recibido de Twilio:', { payload, from, waId });
    // Procesar el payload para extraer el ID de la cita
    let match = payload.match(/(confirmar_cita|cancelar_cita)_(\d+)/);
    if (match) {
        const accion = match[1];
        const citaId = parseInt(match[2], 10);
        if (!isNaN(citaId)) {
            if (accion === 'confirmar_cita') {
                await prisma.appointment.update({ where: { id: citaId.toString() }, data: { status: 'CONFIRMED' } });
                console.log('Cita confirmada:', citaId);
            }
            else if (accion === 'cancelar_cita') {
                await prisma.appointment.update({ where: { id: citaId.toString() }, data: { status: 'CANCELLED' } });
                console.log('Cita cancelada:', citaId);
            }
        }
    }
    else {
        console.log('Payload no reconocido o sin ID de cita:', payload);
    }
    res.status(200).send('OK');
});
exports.default = router;
