import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';
import { randomBytes } from 'crypto';

const prisma = new PrismaClient();

function formatPatientDate(patient: any) {
  return {
    ...patient,
    birthDate: patient.birthDate ? patient.birthDate.toISOString().split('T')[0] : null
  };
}

export const createPatient = async (req: Request, res: Response) => {
  try {
    const { name, lastNamePaterno, lastNameMaterno, email, phone, birthDate, address } = req.body;

    // Crear paciente directamente, sin usuario
    const patient = await prisma.patient.create({
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

    res.status(201).json({ patient: formatPatientDate(patient) });
  } catch (error) {
    res.status(500).json({ error: 'Error al crear paciente' });
  }
};

export const getPatients = async (req: Request, res: Response) => {
  try {
    let patients;
    if (req.user?.role === 'ADMIN') {
      // El admin ve todos los pacientes
      patients = await prisma.patient.findMany({
        include: {
          medicalHistory: true,
          appointments: true
        }
      });
    } else {
      // Los demás solo ven los suyos
      patients = await prisma.patient.findMany({
        where: {
          userId: req.user!.id
        },
        include: {
          medicalHistory: true,
          appointments: true
        }
      });
    }
    res.json(patients.map(formatPatientDate));
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
      res.json(formatPatientDate(patient));
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
    res.json(formatPatientDate(patient));
  } catch (error) {
    res.status(500).json({ error: 'Error al actualizar paciente' });
  }
};

export const deletePatient = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    // Buscar el paciente para obtener el userId
    const patient = await prisma.patient.findUnique({ where: { id } });
    if (!patient) {
      res.status(404).json({ error: 'Paciente no encontrado' });
      return;
    }
    // Eliminar datos relacionados primero
    await prisma.appointment.deleteMany({ where: { patientId: id } });
    await prisma.payment.deleteMany({ where: { patientId: id } });
    await prisma.consultation.deleteMany({ where: { patientId: id } });
    await prisma.medicalHistory.deleteMany({ where: { patientId: id } });
    await prisma.odontogram.deleteMany({ where: { patientId: id } });
    // Eliminar el paciente
    await prisma.patient.delete({ where: { id } });
    // Eliminar el usuario relacionado solo si existe userId
    if (patient.userId) {
      await prisma.user.delete({ where: { id: patient.userId } });
    }
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: 'Error al eliminar paciente y usuario relacionado' });
  }
};

// Endpoint temporal para corregir teléfonos de pacientes mexicanos
export const fixMexicanPhones = async (req: Request, res: Response) => {
  try {
    const patients = await prisma.patient.findMany();
    let updated = 0;
    for (const patient of patients) {
      if (patient.phone) {
        let phone = patient.phone.trim();
        // Si ya tiene +52, no hacer nada
        if (phone.startsWith('+52')) continue;
        // Si empieza con 52 pero sin +
        if (phone.startsWith('52')) {
          phone = '+52' + phone.slice(2);
        } else if (phone.length === 10 && phone.match(/^\d{10}$/)) {
          // Si es un número de 10 dígitos, agregar +52
          phone = '+52' + phone;
        } else if (phone.length === 12 && phone.match(/^52\d{10}$/)) {
          // Si es 52 seguido de 10 dígitos, agregar +
          phone = '+52' + phone.slice(2);
        }
        if (phone !== patient.phone) {
          await prisma.patient.update({ where: { id: patient.id }, data: { phone } });
          updated++;
        }
      }
    }
    res.json({ message: `Teléfonos corregidos: ${updated}` });
  } catch (error) {
    res.status(500).json({ error: 'Error al corregir teléfonos' });
  }
}; 