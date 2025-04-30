"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.isPatient = exports.isAssistant = exports.isDentist = exports.isAdmin = exports.authenticateToken = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (!token) {
        res.status(401).json({ error: 'Token no proporcionado' });
        return;
    }
    try {
        const decoded = jsonwebtoken_1.default.verify(token, process.env.JWT_SECRET);
        // Asegúrate de que req.user siempre sea un objeto con id, email y role
        if (typeof decoded === 'string') {
            res.status(403).json({ error: 'Token inválido' });
            return;
        }
        req.user = {
            id: decoded.id,
            email: decoded.email,
            role: decoded.role
        };
        next();
    }
    catch (error) {
        res.status(403).json({ error: 'Token inválido' });
        return;
    }
};
exports.authenticateToken = authenticateToken;
const isAdmin = (req, res, next) => {
    if (!req.user || req.user.role !== 'ADMIN') {
        res.status(403).json({ error: 'Acceso denegado. Se requieren privilegios de administrador' });
        return;
    }
    next();
};
exports.isAdmin = isAdmin;
const isDentist = (req, res, next) => {
    if (!req.user || (req.user.role !== 'DENTIST' && req.user.role !== 'ADMIN')) {
        res.status(403).json({ error: 'Acceso denegado. Se requieren privilegios de odontólogo' });
        return;
    }
    next();
};
exports.isDentist = isDentist;
const isAssistant = (req, res, next) => {
    if (!req.user || (req.user.role !== 'ASSISTANT' && req.user.role !== 'ADMIN')) {
        res.status(403).json({ error: 'Acceso denegado. Se requieren privilegios de asistente' });
        return;
    }
    next();
};
exports.isAssistant = isAssistant;
const isPatient = (req, res, next) => {
    if (!req.user || (req.user.role !== 'PATIENT' && req.user.role !== 'ADMIN')) {
        res.status(403).json({ error: 'Acceso denegado. Se requieren privilegios de paciente' });
        return;
    }
    next();
};
exports.isPatient = isPatient;
