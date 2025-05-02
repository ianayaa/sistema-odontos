import express from 'express';
import { getClinicConfig, updateClinicConfig } from '../controllers/clinicConfigController';

const router = express.Router();

router.get('/', getClinicConfig);
router.put('/', updateClinicConfig);

export default router; 