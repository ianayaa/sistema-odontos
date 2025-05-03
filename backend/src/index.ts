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

dotenv.config();

const app = express();
const prisma = new PrismaClient();

// Manejo de errores no capturados
process.on('uncaughtException', (error) => {
  console.error('Error no capturado:', error);
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('Promesa rechazada no manejada:', reason);
});

app.use(cors());
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