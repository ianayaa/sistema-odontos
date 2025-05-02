import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';
import { randomBytes } from 'crypto';
import { sendSMS, sendWhatsApp } from '../services/notificationService';

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

    // Generar contraseña temporal
    const tempPassword = randomBytes(8).toString('hex');
    const hashedPassword = await bcrypt.hash(tempPassword, 10);

    // Crear usuario paciente
    const user = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        name,
        role: 'PATIENT',
        isActive: true
      }
    });

    // Crear paciente y asociar con el usuario
    const patient = await prisma.patient.create({
      data: {
        name,
        lastNamePaterno,
        lastNameMaterno,
        email,
        phone,
        birthDate: birthDate ? new Date(birthDate) : null,
        address,
        userId: user.id
      }
    });

    // Enviar contraseña temporal por SMS y WhatsApp si hay teléfono
    if (phone) {
      const msg = `Bienvenido a Odontos. Tu usuario es: ${email} y tu contraseña temporal es: ${tempPassword}`;
      try {
        await sendSMS(phone, msg);
        await sendWhatsApp(phone, msg);
      } catch (err) {
        console.error('Error enviando SMS/WhatsApp:', err);
      }
    }

    res.status(201).json({ patient: formatPatientDate(patient), tempPassword });
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
    // Eliminar el usuario relacionado
    await prisma.user.delete({ where: { id: patient.userId } });
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: 'Error al eliminar paciente y usuario relacionado' });
  }
}; 