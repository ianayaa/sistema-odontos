import express, { Request, Response, NextFunction } from 'express';
import { PrismaClient } from '@prisma/client';
import { authenticateToken } from '../middleware/auth';

const router = express.Router();
const prisma = new PrismaClient();

// Tipado manual para Odontogram
export type Odontogram = {
  id: string;
  patientId: string;
  data: any;
  updatedAt: Date;
  createdAt: Date;
};

// Obtener odontograma de un paciente
router.get('/patient/:patientId', authenticateToken, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { patientId } = req.params;
    console.log(`[ODONTOGRAM][GET] patientId: ${patientId}`);
    // Forzamos el tipado manual
    const odontogram = await prisma.odontogram.findUnique({ where: { patientId } }) as Odontogram | null;
    if (!odontogram) {
      console.log(`[ODONTOGRAM][GET] No odontogram found for patientId: ${patientId}`);
      return res.status(404).json({ error: 'Odontograma no encontrado' });
    }
    console.log(`[ODONTOGRAM][GET] Odontogram found for patientId: ${patientId}`);
    return res.json(odontogram);
  } catch (error) {
    console.error(`[ODONTOGRAM][GET][ERROR]`, error);
    next(error);
  }
});

// Crear o actualizar odontograma de un paciente
router.put('/patient/:patientId', authenticateToken, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { patientId } = req.params;
    const { data } = req.body;
    console.log(`[ODONTOGRAM][PUT] patientId: ${patientId} | data:`, data);
    let odontogram = await prisma.odontogram.findUnique({ where: { patientId } }) as Odontogram | null;
    if (!odontogram) {
      odontogram = await prisma.odontogram.create({
        data: {
          patientId,
          data,
        },
      }) as Odontogram;
      console.log(`[ODONTOGRAM][PUT] Created new odontogram for patientId: ${patientId}`);
    } else {
      odontogram = await prisma.odontogram.update({
        where: { patientId },
        data: { data },
      }) as Odontogram;
      console.log(`[ODONTOGRAM][PUT] Updated odontogram for patientId: ${patientId}`);
    }
    return res.json(odontogram);
  } catch (error) {
    console.error(`[ODONTOGRAM][PUT][ERROR]`, error);
    next(error);
  }
});

export default router;
