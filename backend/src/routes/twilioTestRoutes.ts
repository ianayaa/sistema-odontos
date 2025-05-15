import express, { Request, Response } from 'express';
import { sendNotification } from '../services/notificationService';
import twilio from 'twilio';

const router = express.Router();

// Función para envolver async y manejar errores correctamente en Express
function wrapAsync(fn: any) {
  return function(req: any, res: any, next: any) {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
}

// Endpoint para enviar mensaje de cita por WhatsApp con quick replies
router.post('/send-whatsapp-appointment', wrapAsync(async (req: Request, res: Response) => {
  const { to, nombrePaciente, fecha, hora } = req.body;
  if (!to || !nombrePaciente || !fecha || !hora) {
    return res.status(400).json({ success: false, error: 'Faltan parámetros: to, nombrePaciente, fecha, hora' });
  }
  const client = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);
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
  } catch (error) {
    res.status(500).json({ success: false, error: error instanceof Error ? error.message : error });
  }
}));

export default router; 