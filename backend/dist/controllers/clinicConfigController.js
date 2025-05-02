"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateClinicConfig = exports.getClinicConfig = void 0;
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
const getClinicConfig = async (req, res) => {
    try {
        let config = await prisma.clinicConfig.findFirst();
        if (!config) {
            // Si no existe, crea una por defecto
            config = await prisma.clinicConfig.create({
                data: {
                    nombreClinica: 'Odontos',
                    telefono: '',
                    direccion: '',
                    correo: '',
                    horario: '',
                    colorPrincipal: '#b91c1c',
                    logoUrl: ''
                }
            });
        }
        res.json(config);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al obtener la configuración' });
    }
};
exports.getClinicConfig = getClinicConfig;
const updateClinicConfig = async (req, res) => {
    try {
        let config = await prisma.clinicConfig.findFirst();
        if (!config) {
            config = await prisma.clinicConfig.create({ data: req.body });
        }
        else {
            config = await prisma.clinicConfig.update({
                where: { id: config.id },
                data: req.body
            });
        }
        res.json(config);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al actualizar la configuración' });
    }
};
exports.updateClinicConfig = updateClinicConfig;
