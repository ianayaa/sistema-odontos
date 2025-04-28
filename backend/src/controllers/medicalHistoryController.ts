import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const createMedicalHistory = async (req: Request, res: Response) => {
  try {
    const {
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
    } = req.body;
    
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
  } catch (error) {
    res.status(500).json({ error: 'Error al crear historia clínica' });
  }
};

export const getMedicalHistory = async (req: Request, res: Response) => {
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
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener historia clínica' });
  }
};

export const updateMedicalHistory = async (req: Request, res: Response) => {
  try {
    const { patientId } = req.params;
    const {
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
    } = req.body;
    
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
  } catch (error) {
    res.status(500).json({ error: 'Error al actualizar historia clínica' });
  }
};

export const addTreatment = async (req: Request, res: Response) => {
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
  } catch (error) {
    res.status(500).json({ error: 'Error al agregar tratamiento' });
  }
}; 