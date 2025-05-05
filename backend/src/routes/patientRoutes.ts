import express from 'express';
import {
  createPatient,
  getPatients,
  getPatientById,
  updatePatient,
  deletePatient,
  fixMexicanPhones
} from '../controllers/patientController';
import { authenticateToken } from '../middleware/auth';
import { getPatientsWithActiveAppointments } from '../controllers/appointmentController';

const router = express.Router();

router.use(authenticateToken as any);

router.post('/', createPatient);
router.get('/', getPatients);
router.get('/with-active-appointments', getPatientsWithActiveAppointments);
router.get('/:id', getPatientById as any);
router.put('/:id', updatePatient);
router.delete('/:id', deletePatient);
router.post('/fix-mexican-phones', fixMexicanPhones);

export default router; 