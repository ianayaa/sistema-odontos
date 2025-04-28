import express from 'express';
import {
  createAppointment,
  getAppointments,
  updateAppointment,
  cancelAppointment,
  getPatientAppointments
} from '../controllers/appointmentController';
import { authenticateToken } from '../middleware/auth';

const router = express.Router();

router.use(authenticateToken as any);

router.post('/', createAppointment);
router.get('/', getAppointments);
router.put('/:id', updateAppointment);
router.post('/:id/cancel', cancelAppointment);
router.get('/patient/:patientId', getPatientAppointments);

export default router; 