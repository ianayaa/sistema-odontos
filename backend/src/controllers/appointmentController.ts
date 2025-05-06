import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { sendAppointmentReminder } from '../services/notificationService';

const prisma = new PrismaClient();

export const createAppointment = async (req: Request, res: Response) => {
  try {
    console.log('BODY:', req.body);
    const { patientId, date, endDate, duration, notes, status, serviceId, enviarMensaje } = req.body;
    const data: any = {
      patientId,
      userId: req.user!.id,
      date: new Date(date),
      notes,
      status: status || 'SCHEDULED'
    };
    if (endDate) data.endDate = new Date(endDate);
    if (duration !== undefined) data.duration = duration;
    if (serviceId) data.serviceId = serviceId;

    // Validar traslape de citas (dos pasos para evitar errores de linter)
    const start = new Date(date);
    const end = endDate ? new Date(endDate) : new Date(start.getTime() + (duration || 60) * 60000);
    const overlapWithEnd = await prisma.appointment.findFirst({
      where: {
        userId: req.user!.id,
        status: { not: 'CANCELLED' },
        endDate: { not: null },
        date: { lt: end },
        AND: [
          { endDate: { gt: start } }
        ]
      }
    });
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

    // Solo enviar notificación si el usuario lo pidió
    if (enviarMensaje && appointment.patient && appointment.patient.phone) {
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
    console.log('Query params:', { startDate, endDate });
    
    // Ajuste: Si la fecha viene como YYYY-MM-DD, asegúrate de cubrir todo el día
    let startDateObj: Date | undefined = undefined;
    let endDateObj: Date | undefined = undefined;
    if (typeof startDate === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(startDate)) {
      startDateObj = new Date(startDate + 'T00:00:00.000Z');
    } else if (startDate) {
      startDateObj = new Date(startDate as string);
    }
    if (typeof endDate === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(endDate)) {
      endDateObj = new Date(endDate + 'T23:59:59.999Z');
    } else if (endDate) {
      endDateObj = new Date(endDate as string);
    }
    
    console.log('Fechas convertidas:', {
      startDateObj: startDateObj?.toISOString(),
      endDateObj: endDateObj?.toISOString()
    });

    const appointments = await prisma.appointment.findMany({
      where: {
        userId: req.user!.id,
        date: {
          gte: startDateObj,
          lte: endDateObj
        }
      },
      include: {
        patient: true,
        user: true,
        service: true
      },
      orderBy: {
        date: 'asc'
      }
    });

    console.log('Citas encontradas:', appointments.map(a => ({
      id: a.id,
      date: a.date.toISOString(),
      patient: a.patient?.name,
      status: a.status
    })));

    return res.json(appointments);
  } catch (error) {
    console.error('Error al obtener citas:', error);
    return res.status(500).json({ error: 'Error al obtener citas' });
  }
};

export const updateAppointment = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { date, endDate, duration, status, notes, enviarMensaje } = req.body;
    
    // Obtener la cita original para conocer su duración
    const original = await prisma.appointment.findUnique({
      where: { id },
    });
    if (!original) {
      return res.status(404).json({ error: 'Cita no encontrada' });
    }

    const updateData: any = {};
    if (date) updateData.date = new Date(date);
    if (duration !== undefined) updateData.duration = duration;
    if (status) updateData.status = status;
    if (notes !== undefined) updateData.notes = notes;

    // Si se manda endDate explícitamente, úsalo
    if (endDate) {
      updateData.endDate = new Date(endDate);
    } else if (date && (original.duration || original.endDate)) {
      // Si solo se mueve la cita, recalcula endDate
      const dur = duration !== undefined ? duration : original.duration;
      if (dur) {
        updateData.endDate = new Date(new Date(date).getTime() + dur * 60000);
      } else if (original.endDate) {
        // Si no hay duración pero sí endDate, conserva el mismo rango
        const diff = new Date(original.endDate).getTime() - new Date(original.date).getTime();
        updateData.endDate = new Date(new Date(date).getTime() + diff);
      }
    }

    const appointment = await prisma.appointment.update({
      where: { id },
      data: updateData,
      include: {
        patient: true,
        user: true
      }
    });

    // Si se cambió la fecha o el estado, enviar notificación
    if ((date || status) && appointment.patient && appointment.patient.phone && enviarMensaje) {
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
    const { reason, enviarMensaje } = req.body;
    
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
    if (appointment.patient && appointment.patient.phone && enviarMensaje) {
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
    
    console.log('Guardando horario para usuario:', userId);
    console.log('Datos recibidos:', { workingDays, startTime, endTime, blockedHours });

    // Validar datos requeridos
    if (!workingDays || !startTime || !endTime) {
      return res.status(400).json({ 
        error: 'Faltan datos requeridos',
        details: { workingDays, startTime, endTime }
      });
    }

    const schedule = await prisma.dentistSchedule.upsert({
      where: { userId },
      update: { 
        workingDays: workingDays,
        startTime: startTime,
        endTime: endTime,
        blockedHours: blockedHours || []
      },
      create: { 
        userId, 
        workingDays, 
        startTime, 
        endTime, 
        blockedHours: blockedHours || []
      },
    });

    console.log('Horario guardado exitosamente:', schedule);
    return res.json(schedule);
  } catch (error) {
    console.error('Error al guardar horario:', error);
    return res.status(500).json({ 
      error: 'Error al guardar la configuración de horarios',
      details: error instanceof Error ? error.message : 'Error desconocido'
    });
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

// Endpoint para obtener pacientes con cita activa
export const getPatientsWithActiveAppointments = async (req: Request, res: Response) => {
  try {
    const now = new Date();
    // Buscar citas activas (SCHEDULED o CONFIRMED y futura)
    const activeAppointments = await prisma.appointment.findMany({
      where: {
        userId: req.user!.id,
        status: { in: ['SCHEDULED', 'CONFIRMED'] },
        date: { gte: now }
      },
      select: { patientId: true }
    });
    const patientIds = Array.from(new Set(activeAppointments.map(a => a.patientId)));
    if (patientIds.length === 0) {
      res.json([]);
      return;
    }
    const patients = await prisma.patient.findMany({
      where: { id: { in: patientIds } }
    });
    res.json(patients);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener pacientes con cita activa' });
  }
};

// Notificar cambio de cita (reagendada, etc.)
export const notifyAppointmentChange = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { type } = req.body;
    const appointment = await prisma.appointment.findUnique({
      where: { id },
      include: { patient: true, user: true, service: true }
    });
    if (!appointment || !appointment.patient || !appointment.patient.phone) {
      return res.status(404).json({ error: 'Cita o paciente no encontrado.' });
    }
    // Mensaje corto para SMS (Twilio):
    const msg = `Odontos: Cita reagendada ${appointment.service?.name ? '[' + appointment.service.name + ']' : ''} a ${appointment.date.toLocaleDateString('es-MX')} a las ${appointment.date.toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' })}.`;
    await sendAppointmentReminder({
      ...appointment,
      patient: { ...appointment.patient, phone: appointment.patient.phone || '' },
      customMessage: msg
    });
    return res.json({ success: true });
  } catch (error) {
    console.error('Error al notificar cambio de cita:', error);
    return res.status(500).json({ error: 'No se pudo notificar al paciente.' });
  }
};