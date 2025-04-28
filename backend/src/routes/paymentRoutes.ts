import express from 'express';
import {
  createPayment,
  getPayments,
  updatePaymentStatus,
  getPaymentSummary
} from '../controllers/paymentController';
import { authenticateToken } from '../middleware/auth';

const router = express.Router();

router.use(authenticateToken as any);

router.post('/', createPayment);
router.get('/', getPayments);
router.put('/:id/status', updatePaymentStatus);
router.get('/summary', getPaymentSummary);

export default router; 