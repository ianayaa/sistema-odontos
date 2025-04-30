import { Request, Response } from 'express';
import { PrismaClient, DentistSchedule } from '@prisma/client';
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
    console.log('Datos de la cita agendada:', appointment);
    if (appointment.patient.phone) {
      await sendAppointmentReminder({
        ...appointment,
        patient: { ...appointment.patient, phone: appointment.patient.phone || '' }
      });
    }

    return res.status(201).json(appointment);
  } catch (error) {
    return res.status(500).json({ error: 'Error al crear cita' });
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
    return res.json(appointments);
  } catch (error) {
    return res.status(500).json({ error: 'Error al obtener citas' });
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

    return res.json(appointment);
  } catch (error) {
    return res.status(500).json({ error: 'Error al actualizar cita' });
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

    return res.json(appointment);
  } catch (error) {
    return res.status(500).json({ error: 'Error al cancelar cita' });
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
    return res.json(appointments);
  } catch (error) {
    return res.status(500).json({ error: 'Error al obtener citas del paciente' });
  }
};

export const deleteAppointment = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    console.log('Intentando eliminar cita:', id, 'por usuario:', req.user?.id);
    // Busca la cita y verifica que sea del usuario autenticado
    const appointment = await prisma.appointment.findFirst({ where: { id, userId: req.user!.id } });
    if (!appointment) {
      return res.status(404).json({ error: 'Cita no encontrada o no tienes permiso para eliminarla' });
    }
    await prisma.appointment.delete({ where: { id } });
    return res.status(204).send();
  } catch (error) {
    return res.status(500).json({ error: 'Error al eliminar cita' });
  }
};

// Obtener la configuración de horarios/bloqueos del dentista autenticado
export const getDentistSchedule = async (req: Request, res: Response) => {
  try {
    const userId = req.user!.id;
    const schedule = await prisma.dentistSchedule.findUnique({
      where: { userId },
    });
    return res.json(schedule);
  } catch (error) {
    return res.status(500).json({ error: 'Error al obtener la configuración de horarios' });
  }
};

// Actualizar o crear la configuración de horarios/bloqueos del dentista autenticado
export const upsertDentistSchedule = async (req: Request, res: Response) => {
  try {
    const userId = req.user!.id;
    const { workingDays, startTime, endTime, blockedHours } = req.body;
    const schedule = await prisma.dentistSchedule.upsert({
      where: { userId },
      update: { workingDays, startTime, endTime, blockedHours },
      create: { userId, workingDays, startTime, endTime, blockedHours },
    });
    return res.json(schedule);
  } catch (error) {
    return res.status(500).json({ error: 'Error al guardar la configuración de horarios' });
  }
};