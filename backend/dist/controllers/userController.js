"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteUser = exports.updateUser = exports.getUsers = exports.login = exports.createUser = void 0;
const client_1 = require("@prisma/client");
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const prisma = new client_1.PrismaClient();
const createUser = async (req, res) => {
    try {
        const { email, password, name, lastNamePaterno, lastNameMaterno, role } = req.body;
        // Verificar si el usuario ya existe
        const existingUser = await prisma.user.findUnique({
            where: { email }
        });
        if (existingUser) {
            res.status(400).json({ error: 'El usuario ya existe' });
        }
        else {
            // Encriptar contraseña
            const hashedPassword = await bcryptjs_1.default.hash(password, 10);
            const user = await prisma.user.create({
                data: {
                    email,
                    password: hashedPassword,
                    name,
                    lastNamePaterno,
                    lastNameMaterno,
                    role
                }
            });
            res.status(201).json({
                id: user.id,
                email: user.email,
                name: user.name,
                role: user.role
            });
        }
    }
    catch (error) {
        res.status(500).json({ error: 'Error al crear usuario' });
    }
};
exports.createUser = createUser;
const login = async (req, res) => {
    try {
        const { email, password, systemType = 'main' } = req.body;
        const user = await prisma.user.findUnique({
            where: { email }
        });
        if (!user) {
            return res.status(401).json({ error: 'Credenciales inválidas' });
        }
        // Validar el rol según el sistema
        if (systemType === 'main' && !['ADMIN', 'DENTIST', 'ASSISTANT'].includes(user.role)) {
            return res.status(403).json({ error: 'Acceso denegado para este usuario' });
        }
        if (systemType === 'patient-portal' && user.role !== 'PATIENT') {
            return res.status(403).json({ error: 'Acceso denegado para este usuario' });
        }
        const validPassword = await bcryptjs_1.default.compare(password, user.password);
        if (!validPassword) {
            return res.status(401).json({ error: 'Credenciales inválidas' });
        }
        const token = jsonwebtoken_1.default.sign({ id: user.id, email: user.email, role: user.role }, process.env.JWT_SECRET, { expiresIn: '24h' });
        res.json({
            token,
            user: {
                id: user.id,
                email: user.email,
                name: user.name,
                role: user.role
            }
        });
    }
    catch (error) {
        res.status(500).json({ error: 'Error al iniciar sesión' });
    }
};
exports.login = login;
const getUsers = async (req, res) => {
    try {
        const users = await prisma.user.findMany({
            select: {
                id: true,
                email: true,
                name: true,
                lastNamePaterno: true,
                lastNameMaterno: true,
                role: true,
                createdAt: true
            }
        });
        res.json(users);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al obtener usuarios' });
    }
};
exports.getUsers = getUsers;
const updateUser = async (req, res) => {
    try {
        const { id } = req.params;
        const { name, lastNamePaterno, lastNameMaterno, role } = req.body;
        const user = await prisma.user.update({
            where: { id },
            data: {
                name,
                lastNamePaterno,
                lastNameMaterno,
                role
            },
            select: {
                id: true,
                email: true,
                name: true,
                lastNamePaterno: true,
                lastNameMaterno: true,
                role: true,
                createdAt: true
            }
        });
        res.json(user);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al actualizar usuario' });
    }
};
exports.updateUser = updateUser;
const deleteUser = async (req, res) => {
    try {
        const { id } = req.params;
        // No permitir eliminar el admin principal
        const user = await prisma.user.findUnique({ where: { id } });
        if (user?.role === 'ADMIN') {
            return res.status(403).json({ error: 'No se puede eliminar el usuario administrador.' });
        }
        // Buscar pacientes relacionados
        const patients = await prisma.patient.findMany({ where: { userId: id } });
        for (const patient of patients) {
            await prisma.appointment.deleteMany({ where: { patientId: patient.id } });
            await prisma.payment.deleteMany({ where: { patientId: patient.id } });
            await prisma.consultation.deleteMany({ where: { patientId: patient.id } });
            await prisma.medicalHistory.deleteMany({ where: { patientId: patient.id } });
            await prisma.odontogram.deleteMany({ where: { patientId: patient.id } });
            await prisma.patient.delete({ where: { id: patient.id } });
        }
        // Ahora sí, eliminar el usuario
        await prisma.user.delete({ where: { id } });
        res.status(204).send();
    }
    catch (error) {
        res.status(500).json({ error: 'Error al eliminar usuario y sus datos relacionados' });
    }
};
exports.deleteUser = deleteUser;
