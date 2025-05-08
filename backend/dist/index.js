"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cookie_parser_1 = __importDefault(require("cookie-parser"));
const tokenRoutes_1 = __importDefault(require("./routes/tokenRoutes"));
const cors_1 = __importDefault(require("cors"));
const dotenv_1 = __importDefault(require("dotenv"));
const client_1 = require("@prisma/client");
const helmet_1 = __importDefault(require("helmet"));
const compression_1 = __importDefault(require("compression"));
const express_rate_limit_1 = __importDefault(require("express-rate-limit"));
const morgan_1 = __importDefault(require("morgan"));
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
const path_1 = __importDefault(require("path"));
const userController_1 = require("./controllers/userController");
dotenv_1.default.config();
const app = (0, express_1.default)();
app.use((0, cookie_parser_1.default)());
const prisma = new client_1.PrismaClient();
// Habilitar manejo de cookies (necesario para refresh tokens)
// (Ya está habilitado arriba)
// Seguridad HTTP
app.use((0, helmet_1.default)());
// Compresión de respuestas
app.use((0, compression_1.default)());
// Logging de peticiones HTTP
app.use((0, morgan_1.default)('combined'));
// Rate limiting básico
const limiter = (0, express_rate_limit_1.default)({
    windowMs: 15 * 60 * 1000, // 15 minutos
    max: 100, // máximo 100 requests por IP
    standardHeaders: true,
    legacyHeaders: false,
});
app.use(limiter);
// SUGERENCIA: Para logging estructurado, considera integrar winston o pino.
// SUGERENCIA: Para monitoreo de errores, considera integrar Sentry.
// SUGERENCIA: Para cache de consultas, considera integrar Redis (requiere infraestructura Redis).
// Endpoint de healthcheck para Railway
app.get('/api/health', (req, res) => {
    res.status(200).json({ status: 'ok' });
});
// Manejo de errores no capturados
process.on('uncaughtException', (error) => {
    console.error('Error no capturado:', error);
});
process.on('unhandledRejection', (reason, promise) => {
    console.error('Promesa rechazada no manejada:', reason);
});
// Configuración de CORS según entorno
if (process.env.NODE_ENV === 'production') {
    app.use((0, cors_1.default)({
        origin: process.env.FRONTEND_URL || '*',
        credentials: true
    }));
}
else {
    app.use((0, cors_1.default)({
        origin: 'http://localhost:3000',
        credentials: true
    }));
}
app.use(express_1.default.json());
// Rutas
app.use('/api/users', userRoutes_1.default);
app.use('/api/token', tokenRoutes_1.default);
app.use('/api/patients', patientRoutes_1.default);
app.use('/api/appointments', appointmentRoutes_1.default);
app.use('/api/medical-history', medicalHistoryRoutes_1.default);
app.use('/api/payments', paymentRoutes_1.default);
app.use('/api/odontogram', odontogramRoutes_1.default);
app.use('/api/twilio-test', twilioTestRoutes_1.default);
app.use('/api/config', clinicConfigRoutes_1.default);
app.use('/api/shortener', shortenerRoutes_1.default);
app.use('/api/services', serviceRoutes_1.default);
// Endpoint para refrescar access token
// app.post('/api/token/refresh', refreshAccessToken);
// Endpoint para logout seguro
app.post('/api/logout', userController_1.logout);
// Servir archivos estáticos del frontend
const publicPath = process.env.NODE_ENV === 'production'
    ? path_1.default.join(__dirname, 'public')
    : path_1.default.join(__dirname, '..', '..', 'frontend', 'build');
app.use(express_1.default.static(publicPath));
// Para cualquier ruta que no sea API, servir el index.html del frontend
app.get('*', (req, res) => {
    if (!req.path.startsWith('/api')) {
        res.sendFile(path_1.default.join(publicPath, 'index.html'));
    }
});
// Ruta básica
app.get('/', (req, res) => {
    res.json({ message: 'API del Sistema Dental' });
});
const PORT = Number(process.env.PORT) || 3000;
const server = app.listen(PORT, '0.0.0.0', () => {
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
