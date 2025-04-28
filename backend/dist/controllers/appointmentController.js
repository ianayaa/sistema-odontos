"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getPatientAppointments = exports.cancelAppointment = exports.updateAppointment = exports.getAppointments = exports.createAppointment = void 0;
const client_1 = require("@prisma/client");
const notificationService_1 = require("../services/notificationService");
const prisma = new client_1.PrismaClient();
const createAppointment = async (req, res) => {
    try {
        const { patientId, date, notes } = req.body;
        const appointment = await prisma.appointment.create({
            data: {
                patientId,
                userId: req.user.id,
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
            await (0, notificationService_1.sendAppointmentReminder)({
                ...appointment,
                patient: { ...appointment.patient, phone: appointment.patient.phone || '' }
            });
        }
        res.status(201).json(appointment);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al crear cita' });
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
        res.json(appointments);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al obtener citas' });
    }
};
exports.getAppointments = getAppointments;
const updateAppointment = async (req, res) => {
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
            await (0, notificationService_1.sendAppointmentReminder)({
                ...appointment,
                patient: { ...appointment.patient, phone: appointment.patient.phone || '' }
            });
        }
        res.json(appointment);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al actualizar cita' });
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
        if (appointment.patient.phone) {
            await (0, notificationService_1.sendAppointmentReminder)({
                ...appointment,
                patient: { ...appointment.patient, phone: appointment.patient.phone || '' }
            });
        }
        res.json(appointment);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al cancelar cita' });
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
        res.json(appointments);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al obtener citas del paciente' });
    }
};
exports.getPatientAppointments = getPatientAppointments;
