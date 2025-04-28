import express from 'express';
import {
  createMedicalHistory,
  getMedicalHistory,
  updateMedicalHistory,
  addTreatment
} from '../controllers/medicalHistoryController';
import { authenticateToken } from '../middleware/auth';

const router = express.Router();

router.use(authenticateToken as any);

router.post('/', createMedicalHistory);
router.get('/patient/:patientId', getMedicalHistory as any);
router.put('/patient/:patientId', updateMedicalHistory);
router.post('/patient/:patientId/treatment', addTreatment);

export default router; 