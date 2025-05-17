"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fixMexicanPhones = exports.deletePatient = exports.updatePatient = exports.getPatientById = exports.getPatients = exports.createPatient = void 0;
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
function formatPatientDate(patient) {
    return {
        ...patient,
        birthDate: patient.birthDate ? patient.birthDate.toISOString().split('T')[0] : null
    };
}
const createPatient = async (req, res) => {
    try {
        const { name, lastNamePaterno, lastNameMaterno, email, phone, birthDate, address } = req.body;
        // Crear paciente directamente, sin usuario
        const patient = await prisma.patient.create({
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
        res.status(201).json({ patient: formatPatientDate(patient) });
    }
    catch (error) {
        res.status(500).json({ error: 'Error al crear paciente' });
    }
};
exports.createPatient = createPatient;
const getPatients = async (req, res) => {
    try {
        const { search, take } = req.query;
        let patients;
        const takeNum = take ? Math.min(Number(take), 50) : 20;
        if (search && typeof search === 'string' && search.trim().length > 0) {
            const searchTerm = search.trim();
            // Búsqueda avanzada con unaccent (requiere extensión en PostgreSQL)
            patients = await prisma.$queryRaw `
        SELECT id, name, "lastNamePaterno", "lastNameMaterno", email, phone
        FROM "Patient"
        WHERE
          unaccent(name) ILIKE unaccent(${`%${searchTerm}%`})
          OR unaccent("lastNamePaterno") ILIKE unaccent(${`%${searchTerm}%`})
          OR unaccent("lastNameMaterno") ILIKE unaccent(${`%${searchTerm}%`})
          OR unaccent(email) ILIKE unaccent(${`%${searchTerm}%`})
          OR unaccent(phone) ILIKE unaccent(${`%${searchTerm}%`})
        ORDER BY name ASC
        LIMIT ${takeNum}
      `;
        }
        else {
            patients = await prisma.patient.findMany({
                take: takeNum,
                orderBy: { name: 'asc' },
                select: {
                    id: true,
                    name: true,
                    lastNamePaterno: true,
                    lastNameMaterno: true,
                    email: true,
                    phone: true
                }
            });
        }
        res.json(patients.map(formatPatientDate));
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
            res.json(formatPatientDate(patient));
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
        res.json(formatPatientDate(patient));
    }
    catch (error) {
        res.status(500).json({ error: 'Error al actualizar paciente' });
    }
};
exports.updatePatient = updatePatient;
const deletePatient = async (req, res) => {
    try {
        const { id } = req.params;
        // Buscar el paciente para obtener el userId
        const patient = await prisma.patient.findUnique({ where: { id } });
        if (!patient) {
            res.status(404).json({ error: 'Paciente no encontrado' });
            return;
        }
        // Eliminar datos relacionados primero
        await prisma.appointment.deleteMany({ where: { patientId: id } });
        await prisma.payment.deleteMany({ where: { patientId: id } });
        await prisma.consultation.deleteMany({ where: { patientId: id } });
        await prisma.medicalHistory.deleteMany({ where: { patientId: id } });
        await prisma.odontogram.deleteMany({ where: { patientId: id } });
        // Eliminar el paciente
        await prisma.patient.delete({ where: { id } });
        // Eliminar el usuario relacionado solo si existe userId
        if (patient.userId) {
            await prisma.user.delete({ where: { id: patient.userId } });
        }
        res.status(204).send();
    }
    catch (error) {
        res.status(500).json({ error: 'Error al eliminar paciente y usuario relacionado' });
    }
};
exports.deletePatient = deletePatient;
// Endpoint temporal para corregir teléfonos de pacientes mexicanos
const fixMexicanPhones = async (req, res) => {
    try {
        const patients = await prisma.patient.findMany();
        let updated = 0;
        for (const patient of patients) {
            if (patient.phone) {
                let phone = patient.phone.trim();
                // Si ya tiene +52, no hacer nada
                if (phone.startsWith('+52'))
                    continue;
                // Si empieza con 52 pero sin +
                if (phone.startsWith('52')) {
                    phone = '+52' + phone.slice(2);
                }
                else if (phone.length === 10 && phone.match(/^\d{10}$/)) {
                    // Si es un número de 10 dígitos, agregar +52
                    phone = '+52' + phone;
                }
                else if (phone.length === 12 && phone.match(/^52\d{10}$/)) {
                    // Si es 52 seguido de 10 dígitos, agregar +
                    phone = '+52' + phone.slice(2);
                }
                if (phone !== patient.phone) {
                    await prisma.patient.update({ where: { id: patient.id }, data: { phone } });
                    updated++;
                }
            }
        }
        res.json({ message: `Teléfonos corregidos: ${updated}` });
    }
    catch (error) {
        res.status(500).json({ error: 'Error al corregir teléfonos' });
    }
};
exports.fixMexicanPhones = fixMexicanPhones;
