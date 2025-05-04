"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteService = exports.updateService = exports.createService = exports.getServices = void 0;
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
const getServices = async (_req, res) => {
    try {
        const services = await prisma.service.findMany({ orderBy: { name: 'asc' } });
        res.json(services);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al obtener servicios' });
    }
};
exports.getServices = getServices;
const createService = async (req, res) => {
    try {
        const { name, type, duration, price, description, color } = req.body;
        const service = await prisma.service.create({
            data: { name, type, duration, price, description, color }
        });
        res.status(201).json(service);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al crear servicio' });
    }
};
exports.createService = createService;
const updateService = async (req, res) => {
    try {
        const { id } = req.params;
        const { name, type, duration, price, description, color } = req.body;
        const service = await prisma.service.update({
            where: { id },
            data: { name, type, duration, price, description, color }
        });
        res.json(service);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al actualizar servicio' });
    }
};
exports.updateService = updateService;
const deleteService = async (req, res) => {
    try {
        const { id } = req.params;
        await prisma.service.delete({ where: { id } });
        res.status(204).send();
    }
    catch (error) {
        res.status(500).json({ error: 'Error al eliminar servicio' });
    }
};
exports.deleteService = deleteService;
