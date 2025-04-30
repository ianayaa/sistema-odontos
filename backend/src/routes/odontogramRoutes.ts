import express, { NextFunction } from 'express';
import { PrismaClient } from '@prisma/client';
import { authenticateToken } from '../middleware/auth';
import type { Request, Response } from 'express';

const router = express.Router();
const prisma = new PrismaClient();

export type Odontogram = {
  id: string;
  patientId: string;
  data: any;
  updatedAt: Date;
  createdAt: Date;
};

// Obtener odontograma de un paciente
router.get('/patient/:patientId', authenticateToken, async (req, res) => {
  try {
    const { patientId } = req.params;
    console.log(`[ODONTOGRAM][GET] patientId: ${patientId}`);
    const odontogram = await prisma.odontogram.findUnique({ where: { patientId } }) as Odontogram | null;
    if (!odontogram) {
      console.log(`[ODONTOGRAM][GET] No odontogram found for patientId: ${patientId}`);
      res.status(404).json({ error: 'Odontograma no encontrado' });
      return;
    }
    console.log(`[ODONTOGRAM][GET] Odontogram found for patientId: ${patientId}`);
    res.json(odontogram);
  } catch (error) {
    console.error(`[ODONTOGRAM][GET][ERROR]`, error);
    res.status(500).json({ error: 'Error al obtener odontograma' });
  }
});

// Crear o actualizar odontograma de un paciente
router.put('/patient/:patientId', authenticateToken, async (req, res) => {
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
      });
    } else {
      odontogram = await prisma.odontogram.update({
        where: { patientId },
        data: { data },
      });
    }
    res.json(odontogram);
  } catch (error) {
    console.error(`[ODONTOGRAM][PUT][ERROR]`, error);
    res.status(500).json({ error: 'Error al crear/actualizar odontograma' });
  }
});

export default router;
