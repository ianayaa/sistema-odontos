import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const createPayment = async (req: Request, res: Response) => {
  try {
    const { patientId, amount, method, description } = req.body;
    
    const payment = await prisma.payment.create({
      data: {
        patientId,
        amount,
        method,
        description,
        status: 'PENDING'
      }
    });

    res.status(201).json(payment);
  } catch (error) {
    res.status(500).json({ error: 'Error al crear pago' });
  }
};

export const getPayments = async (req: Request, res: Response) => {
  try {
    const { patientId } = req.query;
    
    const payments = await prisma.payment.findMany({
      where: {
        patientId: patientId as string
      },
      include: {
        patient: true
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    res.json(payments);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener pagos' });
  }
};

export const updatePaymentStatus = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    
    const payment = await prisma.payment.update({
      where: { id },
      data: { status }
    });

    res.json(payment);
  } catch (error) {
    res.status(500).json({ error: 'Error al actualizar estado del pago' });
  }
};

export const getPaymentSummary = async (req: Request, res: Response) => {
  try {
    const { startDate, endDate } = req.query;
    
    const payments = await prisma.payment.findMany({
      where: {
        createdAt: {
          gte: startDate ? new Date(startDate as string) : undefined,
          lte: endDate ? new Date(endDate as string) : undefined
        }
      },
      include: {
        patient: true
      }
    });

    const summary = {
      total: payments.reduce((sum, payment) => sum + payment.amount, 0),
      byMethod: payments.reduce((acc, payment) => {
        acc[payment.method] = (acc[payment.method] || 0) + payment.amount;
        return acc;
      }, {} as Record<string, number>),
      byStatus: payments.reduce((acc, payment) => {
        acc[payment.status] = (acc[payment.status] || 0) + payment.amount;
        return acc;
      }, {} as Record<string, number>)
    };

    res.json(summary);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener resumen de pagos' });
  }
}; 