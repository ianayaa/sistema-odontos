import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

import type { RequestHandler } from 'express';

export const getClinicConfig: RequestHandler = async (req, res) => {
  try {
    // Buscar configuración existente
    let config = await prisma.clinicConfig.findFirst();
    
    // Si no existe, crear una configuración por defecto
    if (!config) {
      try {
        config = await prisma.clinicConfig.create({
          data: {
            nombreClinica: 'Odontos',
            telefono: '',
            direccion: '',
            correo: '',
            horario: 'Lunes a Viernes de 9:00 AM a 7:00 PM',
            colorPrincipal: '#b91c1c',
            logoUrl: ''
          }
        });
      } catch (createError: any) {
        console.error('Error al crear configuración por defecto:', createError);
        throw new Error('No se pudo crear la configuración inicial');
      }
    }
    
    res.json(config);
  } catch (error: any) {
    console.error('Error al obtener la configuración:', error);
    res.status(500).json({ 
      error: 'Error al obtener la configuración',
      details: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};

export const updateClinicConfig: RequestHandler = async (req, res) => {
  try {
    const { 
      nombreClinica, 
      telefono, 
      direccion, 
      correo, 
      horario, 
      colorPrincipal, 
      logoUrl 
    } = req.body;

    // Validar campos requeridos
    if (!nombreClinica || !telefono || !direccion || !correo || !horario || !colorPrincipal) {
      res.status(400).json({ 
        error: 'Faltan campos requeridos',
        requiredFields: ['nombreClinica', 'telefono', 'direccion', 'correo', 'horario', 'colorPrincipal']
      });
      return;
    }

    // Preparar datos para actualizar
    const updateData = {
      nombreClinica,
      telefono,
      direccion,
      correo,
      horario,
      colorPrincipal,
      logoUrl: logoUrl || null
    };

    // Buscar configuración existente
    let config = await prisma.clinicConfig.findFirst();
    
    if (!config) {
      // Si no existe, crear una nueva configuración
      config = await prisma.clinicConfig.create({
        data: updateData
      });
    } else {
      // Si existe, actualizar la configuración existente
      config = await prisma.clinicConfig.update({
        where: { id: config.id },
        data: updateData
      });
    }
    
    res.json(config);
  } catch (error: any) {
    console.error('Error al actualizar la configuración:', error);
    res.status(500).json({ 
      error: 'Error al actualizar la configuración',
      details: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
}; 