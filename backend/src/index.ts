import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { PrismaClient } from '@prisma/client';
import patientRoutes from './routes/patientRoutes';
import appointmentRoutes from './routes/appointmentRoutes';
import userRoutes from './routes/userRoutes';
import medicalHistoryRoutes from './routes/medicalHistoryRoutes';
import paymentRoutes from './routes/paymentRoutes';
import odontogramRoutes from './routes/odontogramRoutes';
import twilioTestRoutes from './routes/twilioTestRoutes';
import clinicConfigRoutes from './routes/clinicConfigRoutes';
import shortenerRoutes from './routes/shortenerRoutes';
import serviceRoutes from './routes/serviceRoutes';
import path from 'path';

dotenv.config();

const app = express();
const prisma = new PrismaClient();

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
  app.use(cors({
    origin: process.env.FRONTEND_URL || '*',
    credentials: true
  }));
} else {
  app.use(cors({
    origin: 'http://localhost:3000',
    credentials: true
  }));
}

app.use(express.json());

// Rutas
app.use('/api/users', userRoutes);
app.use('/api/patients', patientRoutes);
app.use('/api/appointments', appointmentRoutes);
app.use('/api/medical-history', medicalHistoryRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/odontogram', odontogramRoutes);
app.use('/api/twilio-test', twilioTestRoutes);
app.use('/api/config', clinicConfigRoutes);
app.use('/api/shortener', shortenerRoutes);
app.use('/api/services', serviceRoutes);

// Servir archivos estáticos del frontend
const publicPath = process.env.NODE_ENV === 'production' 
  ? path.join(__dirname, 'public')
  : path.join(__dirname, '..', '..', 'frontend', 'build');

app.use(express.static(publicPath));

// Para cualquier ruta que no sea API, servir el index.html del frontend
app.get('*', (req, res) => {
  if (!req.path.startsWith('/api')) {
    res.sendFile(path.join(publicPath, 'index.html'));
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