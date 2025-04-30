"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const client_1 = require("@prisma/client");
const auth_1 = require("../middleware/auth");
const router = express_1.default.Router();
const prisma = new client_1.PrismaClient();
// Obtener odontograma de un paciente
router.get('/patient/:patientId', auth_1.authenticateToken, async (req, res) => {
    try {
        const { patientId } = req.params;
        console.log(`[ODONTOGRAM][GET] patientId: ${patientId}`);
        const odontogram = await prisma.odontogram.findUnique({ where: { patientId } });
        if (!odontogram) {
            console.log(`[ODONTOGRAM][GET] No odontogram found for patientId: ${patientId}`);
            res.status(404).json({ error: 'Odontograma no encontrado' });
            return;
        }
        console.log(`[ODONTOGRAM][GET] Odontogram found for patientId: ${patientId}`);
        res.json(odontogram);
    }
    catch (error) {
        console.error(`[ODONTOGRAM][GET][ERROR]`, error);
        res.status(500).json({ error: 'Error al obtener odontograma' });
    }
});
// Crear o actualizar odontograma de un paciente
router.put('/patient/:patientId', auth_1.authenticateToken, async (req, res) => {
    try {
        const { patientId } = req.params;
        const { data } = req.body;
        console.log(`[ODONTOGRAM][PUT] patientId: ${patientId} | data:`, data);
        let odontogram = await prisma.odontogram.findUnique({ where: { patientId } });
        if (!odontogram) {
            odontogram = await prisma.odontogram.create({
                data: {
                    patientId,
                    data,
                },
            });
        }
        else {
            odontogram = await prisma.odontogram.update({
                where: { patientId },
                data: { data },
            });
        }
        res.json(odontogram);
    }
    catch (error) {
        console.error(`[ODONTOGRAM][PUT][ERROR]`, error);
        res.status(500).json({ error: 'Error al crear/actualizar odontograma' });
    }
});
exports.default = router;
