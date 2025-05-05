import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import type { DentistPayment, User } from '@prisma/client';

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
    console.error('Error al crear pago:', error);
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
      total: payments.reduce((sum: number, payment: any) => sum + payment.amount, 0),
      byMethod: payments.reduce((acc: Record<string, number>, payment: any) => {
        acc[payment.method] = (acc[payment.method] || 0) + payment.amount;
        return acc;
      }, {} as Record<string, number>),
      byStatus: payments.reduce((acc: Record<string, number>, payment: any) => {
        acc[payment.status] = (acc[payment.status] || 0) + payment.amount;
        return acc;
      }, {} as Record<string, number>)
    };

    res.json(summary);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener resumen de pagos' });
  }
};

// --- PAGOS A ODONTÓLOGOS ---
export const createDentistPayment = async (req: Request, res: Response) => {
  try {
    const { dentistId, period, baseSalary, commission, deductions, total, status, paymentDate } = req.body;
    const payment = await prisma.dentistPayment.create({
      data: {
        dentistId,
        period,
        baseSalary: parseFloat(baseSalary),
        commission: parseFloat(commission),
        deductions: parseFloat(deductions),
        total: parseFloat(total),
        status,
        paymentDate: new Date(paymentDate)
      },
      include: { dentist: true }
    });
    res.status(201).json(payment);
  } catch (error) {
    res.status(500).json({ error: 'Error al crear pago a odontólogo' });
  }
};

export const getDentistPayments = async (req: Request, res: Response) => {
  try {
    const payments = await prisma.dentistPayment.findMany({
      include: { dentist: true },
      orderBy: { createdAt: 'desc' }
    });
    res.json(payments);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener pagos a odontólogos' });
  }
};

export const getDentistPaymentsSummary = async (req: Request, res: Response) => {
  try {
    const payments = await prisma.dentistPayment.findMany();
    const totalPaid = payments.filter(p => p.status === 'paid').reduce((sum, p) => sum + p.total, 0);
    const totalPending = payments.filter(p => p.status === 'pending').reduce((sum, p) => sum + p.total, 0);
    const totalCommission = payments.reduce((sum, p) => sum + p.commission, 0);
    const avgCommission = payments.length > 0 ? (payments.reduce((sum, p) => sum + p.commission, 0) / payments.length) : 0;
    res.json({
      totalPaid,
      totalPending,
      totalCommission,
      avgCommission
    });
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener resumen de pagos a odontólogos' });
  }
};

export const deletePayment = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const payment = await prisma.payment.findUnique({ where: { id } });
    if (!payment) {
      return res.status(404).json({ error: 'Pago no encontrado' });
    }
    await prisma.payment.delete({ where: { id } });
    return res.status(204).send();
  } catch (error) {
    return res.status(500).json({ error: 'Error al eliminar pago' });
  }
}; 