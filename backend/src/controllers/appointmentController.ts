import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { sendAppointmentReminder } from '../services/notificationService';

const prisma = new PrismaClient();

export const createAppointment = async (req: Request, res: Response) => {
  try {
    const { patientId, date, notes } = req.body;
    const appointment = await prisma.appointment.create({
      data: {
        patientId,
        userId: req.user!.id,
        date: new Date(date),
        notes,
        status: 'SCHEDULED'
      },
      include: {
        patient: true,
        user: true
      }
    });

    // Enviar notificación de confirmación
    if (appointment.patient.phone) {
      await sendAppointmentReminder({
        ...appointment,
        patient: { ...appointment.patient, phone: appointment.patient.phone || '' }
      });
    }

    res.status(201).json(appointment);
  } catch (error) {
    res.status(500).json({ error: 'Error al crear cita' });
  }
};

export const getAppointments = async (req: Request, res: Response) => {
  try {
    const { startDate, endDate } = req.query;
    const appointments = await prisma.appointment.findMany({
      where: {
        userId: req.user!.id,
        date: {
          gte: startDate ? new Date(startDate as string) : undefined,
          lte: endDate ? new Date(endDate as string) : undefined
        }
      },
      include: {
        patient: true,
        user: true
      },
      orderBy: {
        date: 'asc'
      }
    });
    res.json(appointments);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener citas' });
  }
};

export const updateAppointment = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { date, status, notes } = req.body;
    
    const appointment = await prisma.appointment.update({
      where: { id },
      data: {
        date: date ? new Date(date) : undefined,
        status,
        notes
      },
      include: {
        patient: true,
        user: true
      }
    });

    // Si se cambió la fecha o el estado, enviar notificación
    if ((date || status) && appointment.patient.phone) {
      await sendAppointmentReminder({
        ...appointment,
        patient: { ...appointment.patient, phone: appointment.patient.phone || '' }
      });
    }

    res.json(appointment);
  } catch (error) {
    res.status(500).json({ error: 'Error al actualizar cita' });
  }
};

export const cancelAppointment = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { reason } = req.body;
    
    const appointment = await prisma.appointment.update({
      where: { id },
      data: {
        status: 'CANCELLED',
        notes: reason ? `Cancelada: ${reason}` : 'Cancelada'
      },
      include: {
        patient: true,
        user: true
      }
    });

    // Enviar notificación de cancelación
    if (appointment.patient.phone) {
      await sendAppointmentReminder({
        ...appointment,
        patient: { ...appointment.patient, phone: appointment.patient.phone || '' }
      });
    }

    res.json(appointment);
  } catch (error) {
    res.status(500).json({ error: 'Error al cancelar cita' });
  }
};

export const getPatientAppointments = async (req: Request, res: Response) => {
  try {
    const { patientId } = req.params;
    const appointments = await prisma.appointment.findMany({
      where: {
        patientId,
        userId: req.user!.id
      },
      include: {
        patient: true,
        user: true
      },
      orderBy: {
        date: 'desc'
      }
    });
    res.json(appointments);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener citas del paciente' });
  }
}; 