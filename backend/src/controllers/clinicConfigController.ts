import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const getClinicConfig = async (req: Request, res: Response) => {
  try {
    let config = await prisma.clinicConfig.findFirst();
    if (!config) {
      // Si no existe, crea una por defecto
      config = await prisma.clinicConfig.create({
        data: {
          nombreClinica: 'Odontos',
          telefono: '',
          direccion: '',
          correo: '',
          horario: '',
          colorPrincipal: '#b91c1c',
          logoUrl: ''
        }
      });
    }
    res.json(config);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener la configuración' });
  }
};

export const updateClinicConfig = async (req: Request, res: Response) => {
  try {
    let config = await prisma.clinicConfig.findFirst();
    if (!config) {
      config = await prisma.clinicConfig.create({ data: req.body });
    } else {
      config = await prisma.clinicConfig.update({
        where: { id: config.id },
        data: req.body
      });
    }
    res.json(config);
  } catch (error) {
    res.status(500).json({ error: 'Error al actualizar la configuración' });
  }
}; 