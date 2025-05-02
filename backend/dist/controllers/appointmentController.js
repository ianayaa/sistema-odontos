"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.upsertDentistSchedule = exports.getDentistSchedule = exports.deleteAppointment = exports.getPatientAppointments = exports.cancelAppointment = exports.updateAppointment = exports.getAppointments = exports.createAppointment = void 0;
const client_1 = require("@prisma/client");
const notificationService_1 = require("../services/notificationService");
const prisma = new client_1.PrismaClient();
const createAppointment = async (req, res) => {
    try {
        console.log('BODY:', req.body);
        const { patientId, date, endDate, duration, notes, status } = req.body;
        const data = {
            patientId,
            userId: req.user.id,
            date: new Date(date),
            notes,
            status: status || 'SCHEDULED'
        };
        if (endDate)
            data.endDate = new Date(endDate);
        if (duration !== undefined)
            data.duration = duration;
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
            await (0, notificationService_1.sendAppointmentReminder)({
                ...appointment,
                patient: { ...appointment.patient, phone: appointment.patient.phone || '' }
            });
        }
        return res.status(201).json(appointment);
    }
    catch (error) {
        return res.status(500).json({ error: 'Error al crear cita' });
    }
};
exports.createAppointment = createAppointment;
const getAppointments = async (req, res) => {
    try {
        const { startDate, endDate } = req.query;
        const appointments = await prisma.appointment.findMany({
            where: {
                userId: req.user.id,
                date: {
                    gte: startDate ? new Date(startDate) : undefined,
                    lte: endDate ? new Date(endDate) : undefined
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
    }
    catch (error) {
        return res.status(500).json({ error: 'Error al obtener citas' });
    }
};
exports.getAppointments = getAppointments;
const updateAppointment = async (req, res) => {
    try {
        const { id } = req.params;
        const { date, endDate, duration, status, notes } = req.body;
        const updateData = {};
        if (date)
            updateData.date = new Date(date);
        if (endDate)
            updateData.endDate = new Date(endDate);
        if (duration !== undefined)
            updateData.duration = duration;
        if (status)
            updateData.status = status;
        if (notes !== undefined)
            updateData.notes = notes;
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
            await (0, notificationService_1.sendAppointmentReminder)({
                ...appointment,
                patient: { ...appointment.patient, phone: appointment.patient.phone || '' }
            });
        }
        return res.json(appointment);
    }
    catch (error) {
        return res.status(500).json({ error: 'Error al actualizar cita' });
    }
};
exports.updateAppointment = updateAppointment;
const cancelAppointment = async (req, res) => {
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
            await (0, notificationService_1.sendAppointmentReminder)({
                ...appointment,
                patient: { ...appointment.patient, phone: appointment.patient.phone || '' }
            });
        }
        return res.json(appointment);
    }
    catch (error) {
        return res.status(500).json({ error: 'Error al cancelar cita' });
    }
};
exports.cancelAppointment = cancelAppointment;
const getPatientAppointments = async (req, res) => {
    try {
        const { patientId } = req.params;
        const appointments = await prisma.appointment.findMany({
            where: {
                patientId,
                userId: req.user.id
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
    }
    catch (error) {
        return res.status(500).json({ error: 'Error al obtener citas del paciente' });
    }
};
exports.getPatientAppointments = getPatientAppointments;
const deleteAppointment = async (req, res) => {
    try {
        const { id } = req.params;
        console.log('Intentando eliminar cita:', id, 'por usuario:', req.user?.id);
        // Busca la cita y verifica que sea del usuario autenticado
        const appointment = await prisma.appointment.findFirst({ where: { id, userId: req.user.id } });
        if (!appointment) {
            return res.status(404).json({ error: 'Cita no encontrada o no tienes permiso para eliminarla' });
        }
        await prisma.appointment.delete({ where: { id } });
        return res.status(204).send();
    }
    catch (error) {
        return res.status(500).json({ error: 'Error al eliminar cita' });
    }
};
exports.deleteAppointment = deleteAppointment;
// Obtener la configuración de horarios/bloqueos del dentista autenticado
const getDentistSchedule = async (req, res) => {
    try {
        const userId = req.user.id;
        const schedule = await prisma.dentistSchedule.findUnique({
            where: { userId },
        });
        return res.json(schedule);
    }
    catch (error) {
        return res.status(500).json({ error: 'Error al obtener la configuración de horarios' });
    }
};
exports.getDentistSchedule = getDentistSchedule;
// Actualizar o crear la configuración de horarios/bloqueos del dentista autenticado
const upsertDentistSchedule = async (req, res) => {
    try {
        const userId = req.user.id;
        const { workingDays, startTime, endTime, blockedHours } = req.body;
        const schedule = await prisma.dentistSchedule.upsert({
            where: { userId },
            update: { workingDays, startTime, endTime, blockedHours },
            create: { userId, workingDays, startTime, endTime, blockedHours },
        });
        return res.json(schedule);
    }
    catch (error) {
        return res.status(500).json({ error: 'Error al guardar la configuración de horarios' });
    }
};
exports.upsertDentistSchedule = upsertDentistSchedule;
