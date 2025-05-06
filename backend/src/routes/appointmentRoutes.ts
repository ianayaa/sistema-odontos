import express from 'express';
import {
  createAppointment,
  getAppointments,
  updateAppointment,
  cancelAppointment,
  getPatientAppointments,
  deleteAppointment,
  getDentistSchedule,
  upsertDentistSchedule,
  publicConfirmAppointment,
  notifyAppointmentChange
} from '../controllers/appointmentController';
import { authenticateToken, isDentist } from '../middleware/auth';

const router = express.Router();

// Ruta pública para confirmar cita
router.post('/:id/confirm', wrapAsync(publicConfirmAppointment));

router.use(authenticateToken as any);

router.post('/', wrapAsync(createAppointment));
router.get('/', wrapAsync(getAppointments));
router.put('/:id', wrapAsync(updateAppointment));
router.post('/:id/cancel', wrapAsync(cancelAppointment));
router.get('/patient/:patientId', wrapAsync(getPatientAppointments));
router.delete('/:id', wrapAsync(deleteAppointment));

// Nueva ruta para notificar cambio de cita
router.post('/:id/notify', wrapAsync(notifyAppointmentChange));

// Rutas para configuración de horarios/bloqueos del dentista autenticado
router.get('/schedule', isDentist, wrapAsync(getDentistSchedule));
router.post('/schedule', isDentist, wrapAsync(upsertDentistSchedule));

function wrapAsync(fn: any) {
  return function(req: any, res: any, next: any) {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
}

export default router;