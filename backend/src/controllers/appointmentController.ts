import { Request, Response } from 'express';
import { PrismaClient, DentistSchedule, Appointment } from '@prisma/client';
import { sendAppointmentReminder } from '../services/notificationService';

const prisma = new PrismaClient();

export const createAppointment = async (req: Request, res: Response) => {
  try {
    console.log('BODY:', req.body);
    const { patientId, date, endDate, duration, notes, status } = req.body;
    const data: any = {
      patientId,
      userId: req.user!.id,
      date: new Date(date),
      notes,
      status: status || 'SCHEDULED'
    };
    if (endDate) data.endDate = new Date(endDate);
    if (duration !== undefined) data.duration = duration;

    // Validar traslape de citas (dos pasos para evitar errores de linter)
    const start = new Date(date);
    const end = endDate ? new Date(endDate) : new Date(start.getTime() + (duration || 60) * 60000);
    // 1. Buscar traslape con citas que SÍ tienen endDate
    const overlapWithEnd = await prisma.appointment.findFirst({
      where: {
        userId: req.user!.id,
        status: { not: 'CANCELLED' },
        endDate: { not: null },
        date: { lt: end },
        // Prisma no permite dos veces endDate, así que usamos AND
        AND: [
          { endDate: { gt: start } }
        ]
      }
    });
    // 2. Buscar traslape con citas que NO tienen endDate (por compatibilidad)
    const overlapWithoutEnd = await prisma.appointment.findFirst({
      where: {
        userId: req.user!.id,
        status: { not: 'CANCELLED' },
        endDate: null,
        date: { lt: end }
      }
    });
    if (overlapWithEnd || overlapWithoutEnd) {
      return res.status(400).json({ error: 'Ya existe una cita en ese horario.' });
    }

    const appointment = await prisma.appointment.create({
      data,
      include: {
        patient: true,
        user: true
      }
    });

    // Enviar notificación de confirmación
    console.log('Datos de la cita agendada:', appointment);
    if (appointment.patient && appointment.patient.phone) {
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
    const { date, endDate, duration, status, notes } = req.body;
    
    const updateData: any = {};
    if (date) updateData.date = new Date(date);
    if (endDate) updateData.endDate = new Date(endDate);
    if (duration !== undefined) updateData.duration = duration;
    if (status) updateData.status = status;
    if (notes !== undefined) updateData.notes = notes;
    const appointment = await prisma.appointment.update({
      where: { id },
      data: updateData,
      include: {
        patient: true,
        user: true
      }
    });

    // Si se cambió la fecha o el estado, enviar notificación
    if ((date || status) && appointment.patient && appointment.patient.phone) {
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
    if (appointment.patient && appointment.patient.phone) {
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

export const publicConfirmAppointment = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const appointment = await prisma.appointment.findUnique({ where: { id } });
    if (!appointment) {
      return res.status(404).json({ error: 'Cita no encontrada' });
    }
    if (appointment.status === 'CONFIRMED') {
      return res.status(400).json({ error: 'La cita ya está confirmada.' });
    }
    if (appointment.status === 'CANCELLED') {
      return res.status(400).json({ error: 'La cita fue cancelada.' });
    }
    await prisma.appointment.update({
      where: { id },
      data: { status: 'CONFIRMED' }
    });
    return res.json({ success: true });
  } catch (error) {
    return res.status(500).json({ error: 'Error al confirmar cita' });
  }
};