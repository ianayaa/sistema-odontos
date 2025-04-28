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

dotenv.config();

const app = express();
const prisma = new PrismaClient();

app.use(cors());
app.use(express.json());

// Rutas
app.use('/api/users', userRoutes);
app.use('/api/patients', patientRoutes);
app.use('/api/appointments', appointmentRoutes);
app.use('/api/medical-history', medicalHistoryRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/odontogram', odontogramRoutes);

// Ruta básica
app.get('/', (req, res) => {
  res.json({ message: 'API del Sistema Dental' });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`);
}); 