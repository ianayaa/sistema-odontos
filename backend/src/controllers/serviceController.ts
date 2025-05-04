import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const getServices = async (_req: Request, res: Response) => {
  try {
    const services = await prisma.service.findMany({ orderBy: { name: 'asc' } });
    res.json(services);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener servicios' });
  }
};

export const createService = async (req: Request, res: Response) => {
  try {
    const { name, type, duration, price, description, color } = req.body;
    const service = await prisma.service.create({
      data: { name, type, duration, price, description, color }
    });
    res.status(201).json(service);
  } catch (error) {
    res.status(500).json({ error: 'Error al crear servicio' });
  }
};

export const updateService = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { name, type, duration, price, description, color } = req.body;
    const service = await prisma.service.update({
      where: { id },
      data: { name, type, duration, price, description, color }
    });
    res.json(service);
  } catch (error) {
    res.status(500).json({ error: 'Error al actualizar servicio' });
  }
};

export const deleteService = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    await prisma.service.delete({ where: { id } });
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: 'Error al eliminar servicio' });
  }
}; 