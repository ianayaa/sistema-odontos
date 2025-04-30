import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const createPatient = async (req: Request, res: Response) => {
  try {
    const { name, lastNamePaterno, lastNameMaterno, email, phone, birthDate, address } = req.body;
    const patient = await prisma.patient.create({
      data: {
        name,
        lastNamePaterno,
        lastNameMaterno,
        email,
        phone,
        birthDate: birthDate ? new Date(birthDate) : null,
        address,
        userId: req.user!.id // Asumimos que el usuario está autenticado
      }
    });
    res.status(201).json(patient);
  } catch (error) {
    res.status(500).json({ error: 'Error al crear paciente' });
  }
};

export const getPatients = async (req: Request, res: Response) => {
  try {
    const patients = await prisma.patient.findMany({
      where: {
        userId: req.user!.id
      },
      include: {
        medicalHistory: true,
        appointments: true
      }
    });
    res.json(patients);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener pacientes' });
  }
};

export const getPatientById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const patient = await prisma.patient.findUnique({
      where: { id },
      include: {
        medicalHistory: true,
        appointments: true,
        payments: true
      }
    });
    if (!patient) {
      res.status(404).json({ error: 'Paciente no encontrado' });
    } else {
      res.json(patient);
    }
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener paciente' });
  }
};

export const updatePatient = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { name, lastNamePaterno, lastNameMaterno, email, phone, birthDate, address } = req.body;
    const patient = await prisma.patient.update({
      where: { id },
      data: {
        name,
        lastNamePaterno,
        lastNameMaterno,
        email,
        phone,
        birthDate: birthDate ? new Date(birthDate) : null,
        address
      }
    });
    res.json(patient);
  } catch (error) {
    res.status(500).json({ error: 'Error al actualizar paciente' });
  }
};

export const deletePatient = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    // Eliminar datos relacionados primero
    await prisma.appointment.deleteMany({ where: { patientId: id } });
    await prisma.payment.deleteMany({ where: { patientId: id } });
    await prisma.consultation.deleteMany({ where: { patientId: id } });
    await prisma.medicalHistory.deleteMany({ where: { patientId: id } });
    await prisma.odontogram.deleteMany({ where: { patientId: id } });
    // Finalmente, eliminar el paciente
    await prisma.patient.delete({ where: { id } });
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: 'Error al eliminar paciente y sus datos relacionados' });
  }
}; 