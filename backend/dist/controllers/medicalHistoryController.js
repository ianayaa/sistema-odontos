"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.addTreatment = exports.updateMedicalHistory = exports.getMedicalHistory = exports.createMedicalHistory = void 0;
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
const MEDICAL_HISTORY_FIELDS = [
    'patientId', 'nombreCompleto', 'apellidoPaterno', 'apellidoMaterno', 'empleoProfesion', 'sexo', 'edad', 'estadoCivil', 'fechaNacimiento', 'lugarNacimiento', 'domicilio', 'telefonoDomicilio', 'telefonoOficina', 'escolaridad', 'ocupacion', 'interrogatorioTipo', 'nombreInformante', 'parentescoInformante', 'respuesta', 'temperatura', 'presionArterial', 'frecuenciaCardiaca', 'urgencia', 'compania', 'motivoConsulta', 'fechaUltimaConsultaMedica', 'motivoUltimaConsultaMedica', 'padecimientoOdontologicoActual', 'tipoSanguineo', 'rh', 'hepatitisA', 'hepatitisB', 'hepatitisC', 'hepatitisD', 'vih', 'herpes', 'alergias', 'terapeuticaEmpleada', 'saludGeneral', 'nerviosismoDental', 'convulsiones', 'asma', 'bronquitis', 'enfisema', 'fuma', 'cigarrillosPorDia', 'taquicardia', 'bradicardia', 'hipertension', 'hipotension', 'doloresPecho', 'infarto', 'angina', 'fiebreReumatica', 'edadFiebreReumatica', 'sangrado', 'extracciones', 'sangradoNasal', 'cortaduras', 'periodoMenstrual', 'fum', 'embarazo', 'mesesEmbarazo', 'padecimientosGastricos', 'diabetes', 'diabetesControlMedico', 'hipotiroidismo', 'hipertiroidismo', 'hepatitisHigado', 'cirrosis', 'problemasRinonUrinarias', 'medicamentosActuales', 'otrasCondicionesMedicas', 'procesosQuirurgicos', 'tratamientosHormonales', 'notes'
];
function filterMedicalHistoryData(data) {
    const filtered = {};
    for (const key of MEDICAL_HISTORY_FIELDS) {
        if (Object.prototype.hasOwnProperty.call(data, key)) {
            filtered[key] = data[key];
        }
    }
    return filtered;
}
const createMedicalHistory = async (req, res) => {
    try {
        let data = req.body;
        data = filterMedicalHistoryData(data);
        // Conversión robusta de campos numéricos
        data.edad = (!data.edad || data.edad === '' || isNaN(Number(data.edad))) ? null : Number(data.edad);
        data.cigarrillosPorDia = (!data.cigarrillosPorDia || data.cigarrillosPorDia === '' || isNaN(Number(data.cigarrillosPorDia))) ? null : Number(data.cigarrillosPorDia);
        data.edadFiebreReumatica = (!data.edadFiebreReumatica || data.edadFiebreReumatica === '' || isNaN(Number(data.edadFiebreReumatica))) ? null : Number(data.edadFiebreReumatica);
        data.mesesEmbarazo = (!data.mesesEmbarazo || data.mesesEmbarazo === '' || isNaN(Number(data.mesesEmbarazo))) ? null : Number(data.mesesEmbarazo);
        // Conversión robusta de campos de fecha
        if (!data.fechaNacimiento || data.fechaNacimiento === '') {
            data.fechaNacimiento = null;
        }
        else {
            data.fechaNacimiento = new Date(data.fechaNacimiento).toISOString();
        }
        if (!data.fechaUltimaConsultaMedica || data.fechaUltimaConsultaMedica === '') {
            data.fechaUltimaConsultaMedica = null;
        }
        else {
            data.fechaUltimaConsultaMedica = new Date(data.fechaUltimaConsultaMedica).toISOString();
        }
        if (!data.fum || data.fum === '') {
            data.fum = null;
        }
        else {
            data.fum = new Date(data.fum).toISOString();
        }
        const medicalHistory = await prisma.medicalHistory.create({
            data
        });
        res.status(201).json(medicalHistory);
    }
    catch (error) {
        console.error(error);
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
        console.error(error);
        res.status(500).json({ error: 'Error al obtener historia clínica' });
    }
};
exports.getMedicalHistory = getMedicalHistory;
const updateMedicalHistory = async (req, res) => {
    try {
        const { patientId } = req.params;
        let data = req.body;
        data = filterMedicalHistoryData(data);
        // Conversión robusta de campos numéricos
        data.edad = (!data.edad || data.edad === '' || isNaN(Number(data.edad))) ? null : Number(data.edad);
        data.cigarrillosPorDia = (!data.cigarrillosPorDia || data.cigarrillosPorDia === '' || isNaN(Number(data.cigarrillosPorDia))) ? null : Number(data.cigarrillosPorDia);
        data.edadFiebreReumatica = (!data.edadFiebreReumatica || data.edadFiebreReumatica === '' || isNaN(Number(data.edadFiebreReumatica))) ? null : Number(data.edadFiebreReumatica);
        data.mesesEmbarazo = (!data.mesesEmbarazo || data.mesesEmbarazo === '' || isNaN(Number(data.mesesEmbarazo))) ? null : Number(data.mesesEmbarazo);
        // Conversión robusta de campos de fecha
        if (!data.fechaNacimiento || data.fechaNacimiento === '') {
            data.fechaNacimiento = null;
        }
        else {
            data.fechaNacimiento = new Date(data.fechaNacimiento).toISOString();
        }
        if (!data.fechaUltimaConsultaMedica || data.fechaUltimaConsultaMedica === '') {
            data.fechaUltimaConsultaMedica = null;
        }
        else {
            data.fechaUltimaConsultaMedica = new Date(data.fechaUltimaConsultaMedica).toISOString();
        }
        if (!data.fum || data.fum === '') {
            data.fum = null;
        }
        else {
            data.fum = new Date(data.fum).toISOString();
        }
        const medicalHistory = await prisma.medicalHistory.update({
            where: { patientId },
            data
        });
        res.json(medicalHistory);
    }
    catch (error) {
        console.error(error);
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
        console.error(error);
        res.status(500).json({ error: 'Error al agregar tratamiento' });
    }
};
exports.addTreatment = addTreatment;
