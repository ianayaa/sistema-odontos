"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deletePatient = exports.updatePatient = exports.getPatientById = exports.getPatients = exports.createPatient = void 0;
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
const createPatient = async (req, res) => {
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
                userId: req.user.id // Asumimos que el usuario está autenticado
            }
        });
        res.status(201).json(patient);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al crear paciente' });
    }
};
exports.createPatient = createPatient;
const getPatients = async (req, res) => {
    try {
        const patients = await prisma.patient.findMany({
            where: {
                userId: req.user.id
            },
            include: {
                medicalHistory: true,
                appointments: true
            }
        });
        res.json(patients);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al obtener pacientes' });
    }
};
exports.getPatients = getPatients;
const getPatientById = async (req, res) => {
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
        }
        else {
            res.json(patient);
        }
    }
    catch (error) {
        res.status(500).json({ error: 'Error al obtener paciente' });
    }
};
exports.getPatientById = getPatientById;
const updatePatient = async (req, res) => {
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
    }
    catch (error) {
        res.status(500).json({ error: 'Error al actualizar paciente' });
    }
};
exports.updatePatient = updatePatient;
const deletePatient = async (req, res) => {
    try {
        const { id } = req.params;
        await prisma.patient.delete({
            where: { id }
        });
        res.status(204).send();
    }
    catch (error) {
        res.status(500).json({ error: 'Error al eliminar paciente' });
    }
};
exports.deletePatient = deletePatient;
