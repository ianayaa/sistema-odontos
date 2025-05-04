import express from 'express';
import {
  createPayment,
  getPayments,
  updatePaymentStatus,
  getPaymentSummary,
  createDentistPayment,
  getDentistPayments,
  getDentistPaymentsSummary
} from '../controllers/paymentController';
import { authenticateToken } from '../middleware/auth';

const router = express.Router();

router.use(authenticateToken as any);

router.post('/', createPayment);
router.get('/', getPayments);
router.put('/:id/status', updatePaymentStatus);
router.get('/summary', getPaymentSummary);
router.post('/dentist', createDentistPayment);
router.get('/dentist', getDentistPayments);
router.get('/dentist/summary', getDentistPaymentsSummary);

export default router; 