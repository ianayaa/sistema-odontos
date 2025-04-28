"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.addTreatment = exports.updateMedicalHistory = exports.getMedicalHistory = exports.createMedicalHistory = void 0;
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
const createMedicalHistory = async (req, res) => {
    try {
        const { patientId, motivo, padecimientoActual, antecedentesPatologicos, antecedentesNoPatologicos, interrogatorio, alergias, medicamentos, enfermedades, exploracionFisica, exploracionBucal, diagnostico, pronostico, planTratamiento, consentimiento, notes } = req.body;
        const medicalHistory = await prisma.medicalHistory.create({
            data: {
                patientId,
                motivo,
                padecimientoActual,
                antecedentesPatologicos,
                antecedentesNoPatologicos,
                interrogatorio,
                alergias,
                medicamentos,
                enfermedades,
                exploracionFisica,
                exploracionBucal,
                diagnostico,
                pronostico,
                planTratamiento,
                consentimiento,
                notes
            }
        });
        res.status(201).json(medicalHistory);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al crear historia clínica' });
    }
};
exports.createMedicalHistory = createMedicalHistory;
const getMedicalHistory = async (req, res) => {
    try {
        const { patientId } = req.params;
        const medicalHistory = await prisma.medicalHistory.findUnique({
            where: { patientId },
            include: {
                patient: true
            }
        });
        if (!medicalHistory) {
            return res.status(404).json({ error: 'Historia clínica no encontrada' });
        }
        res.json(medicalHistory);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al obtener historia clínica' });
    }
};
exports.getMedicalHistory = getMedicalHistory;
const updateMedicalHistory = async (req, res) => {
    try {
        const { patientId } = req.params;
        const { motivo, padecimientoActual, antecedentesPatologicos, antecedentesNoPatologicos, interrogatorio, alergias, medicamentos, enfermedades, exploracionFisica, exploracionBucal, diagnostico, pronostico, planTratamiento, consentimiento, notes } = req.body;
        const medicalHistory = await prisma.medicalHistory.update({
            where: { patientId },
            data: {
                motivo,
                padecimientoActual,
                antecedentesPatologicos,
                antecedentesNoPatologicos,
                interrogatorio,
                alergias,
                medicamentos,
                enfermedades,
                exploracionFisica,
                exploracionBucal,
                diagnostico,
                pronostico,
                planTratamiento,
                consentimiento,
                notes
            }
        });
        res.json(medicalHistory);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al actualizar historia clínica' });
    }
};
exports.updateMedicalHistory = updateMedicalHistory;
const addTreatment = async (req, res) => {
    try {
        const { patientId } = req.params;
        const { treatment, date, notes } = req.body;
        const medicalHistory = await prisma.medicalHistory.update({
            where: { patientId },
            data: {
                notes: `${notes || ''}\n\nTratamiento: ${treatment}\nFecha: ${new Date(date).toLocaleDateString()}\nNotas: ${notes || 'Sin notas adicionales'}`
            }
        });
        res.json(medicalHistory);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al agregar tratamiento' });
    }
};
exports.addTreatment = addTreatment;
