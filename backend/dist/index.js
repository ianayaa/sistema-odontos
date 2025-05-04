"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const dotenv_1 = __importDefault(require("dotenv"));
const client_1 = require("@prisma/client");
const patientRoutes_1 = __importDefault(require("./routes/patientRoutes"));
const appointmentRoutes_1 = __importDefault(require("./routes/appointmentRoutes"));
const userRoutes_1 = __importDefault(require("./routes/userRoutes"));
const medicalHistoryRoutes_1 = __importDefault(require("./routes/medicalHistoryRoutes"));
const paymentRoutes_1 = __importDefault(require("./routes/paymentRoutes"));
const odontogramRoutes_1 = __importDefault(require("./routes/odontogramRoutes"));
const twilioTestRoutes_1 = __importDefault(require("./routes/twilioTestRoutes"));
const clinicConfigRoutes_1 = __importDefault(require("./routes/clinicConfigRoutes"));
const shortenerRoutes_1 = __importDefault(require("./routes/shortenerRoutes"));
const serviceRoutes_1 = __importDefault(require("./routes/serviceRoutes"));
dotenv_1.default.config();
const app = (0, express_1.default)();
const prisma = new client_1.PrismaClient();
// Manejo de errores no capturados
process.on('uncaughtException', (error) => {
    console.error('Error no capturado:', error);
});
process.on('unhandledRejection', (reason, promise) => {
    console.error('Promesa rechazada no manejada:', reason);
});
app.use((0, cors_1.default)());
app.use(express_1.default.json());
// Rutas
app.use('/api/users', userRoutes_1.default);
app.use('/api/patients', patientRoutes_1.default);
app.use('/api/appointments', appointmentRoutes_1.default);
app.use('/api/medical-history', medicalHistoryRoutes_1.default);
app.use('/api/payments', paymentRoutes_1.default);
app.use('/api/odontogram', odontogramRoutes_1.default);
app.use('/api/twilio-test', twilioTestRoutes_1.default);
app.use('/api/config', clinicConfigRoutes_1.default);
app.use('/api/shortener', shortenerRoutes_1.default);
app.use('/api/services', serviceRoutes_1.default);
// Ruta básica
app.get('/', (req, res) => {
    res.json({ message: 'API del Sistema Dental' });
});
const PORT = process.env.PORT || 3000;
const server = app.listen(PORT, () => {
    console.log(`Servidor corriendo en puerto ${PORT}`);
});
// Manejo de señales de terminación
process.on('SIGTERM', () => {
    console.log('Recibida señal SIGTERM, cerrando servidor...');
    server.close(() => {
        console.log('Servidor cerrado');
        process.exit(0);
    });
});
process.on('SIGINT', () => {
    console.log('Recibida señal SIGINT, cerrando servidor...');
    server.close(() => {
        console.log('Servidor cerrado');
        process.exit(0);
    });
});
