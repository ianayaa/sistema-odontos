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
        const { email, password, name, role } = req.body;
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
        const { email, password } = req.body;
        const user = await prisma.user.findUnique({
            where: { email }
        });
        if (!user) {
            res.status(401).json({ error: 'Credenciales inválidas' });
        }
        else {
            const validPassword = await bcryptjs_1.default.compare(password, user.password);
            if (!validPassword) {
                res.status(401).json({ error: 'Credenciales inválidas' });
            }
            else {
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
        }
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
        const { name, role } = req.body;
        const user = await prisma.user.update({
            where: { id },
            data: {
                name,
                role
            },
            select: {
                id: true,
                email: true,
                name: true,
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
        await prisma.user.delete({
            where: { id }
        });
        res.status(204).send();
    }
    catch (error) {
        res.status(500).json({ error: 'Error al eliminar usuario' });
    }
};
exports.deleteUser = deleteUser;
