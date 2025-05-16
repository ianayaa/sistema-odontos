"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deletePayment = exports.getDentistPaymentsSummary = exports.getDentistPayments = exports.createDentistPayment = exports.getPaymentSummary = exports.updatePaymentStatus = exports.getPayments = exports.createPayment = void 0;
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
const createPayment = async (req, res) => {
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
    }
    catch (error) {
        console.error('Error al crear pago:', error);
        res.status(500).json({ error: 'Error al crear pago' });
    }
};
exports.createPayment = createPayment;
const getPayments = async (req, res) => {
    try {
        const { patientId } = req.query;
        const payments = await prisma.payment.findMany({
            where: {
                patientId: patientId
            },
            include: {
                patient: {
                    select: {
                        id: true,
                        name: true,
                        lastNamePaterno: true,
                        lastNameMaterno: true
                    }
                }
            },
            orderBy: {
                createdAt: 'desc'
            }
        });
        const paymentsWithDate = payments.map((p) => ({ ...p, date: p.createdAt }));
        res.json(paymentsWithDate);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al obtener pagos' });
    }
};
exports.getPayments = getPayments;
const updatePaymentStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const { status } = req.body;
        const payment = await prisma.payment.update({
            where: { id },
            data: { status }
        });
        res.json(payment);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al actualizar estado del pago' });
    }
};
exports.updatePaymentStatus = updatePaymentStatus;
const getPaymentSummary = async (req, res) => {
    try {
        const { startDate, endDate } = req.query;
        const payments = await prisma.payment.findMany({
            where: {
                createdAt: {
                    gte: startDate ? new Date(startDate) : undefined,
                    lte: endDate ? new Date(endDate) : undefined
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
            }, {}),
            byStatus: payments.reduce((acc, payment) => {
                acc[payment.status] = (acc[payment.status] || 0) + payment.amount;
                return acc;
            }, {})
        };
        res.json(summary);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al obtener resumen de pagos' });
    }
};
exports.getPaymentSummary = getPaymentSummary;
// --- PAGOS A ODONTÓLOGOS ---
const createDentistPayment = async (req, res) => {
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
    }
    catch (error) {
        res.status(500).json({ error: 'Error al crear pago a odontólogo' });
    }
};
exports.createDentistPayment = createDentistPayment;
const getDentistPayments = async (req, res) => {
    try {
        const payments = await prisma.dentistPayment.findMany({
            include: { dentist: true },
            orderBy: { createdAt: 'desc' }
        });
        res.json(payments);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al obtener pagos a odontólogos' });
    }
};
exports.getDentistPayments = getDentistPayments;
const getDentistPaymentsSummary = async (req, res) => {
    try {
        const payments = await prisma.dentistPayment.findMany({
            include: {
                dentist: {
                    select: {
                        id: true,
                        name: true
                    }
                }
            }
        });
        const totalPaid = payments
            .filter((p) => p.status === 'paid')
            .reduce((sum, p) => sum + p.total, 0);
        const totalPending = payments
            .filter((p) => p.status === 'pending')
            .reduce((sum, p) => sum + p.total, 0);
        const totalCommission = payments.reduce((sum, p) => sum + p.commission, 0);
        const avgCommission = payments.length > 0
            ? (payments.reduce((sum, p) => sum + p.commission, 0) / payments.length)
            : 0;
        res.json({
            totalPaid,
            totalPending,
            totalCommission,
            avgCommission
        });
    }
    catch (error) {
        res.status(500).json({ error: 'Error al obtener resumen de pagos a odontólogos' });
    }
};
exports.getDentistPaymentsSummary = getDentistPaymentsSummary;
const deletePayment = async (req, res) => {
    try {
        const { id } = req.params;
        const payment = await prisma.payment.findUnique({ where: { id } });
        if (!payment) {
            return res.status(404).json({ error: 'Pago no encontrado' });
        }
        await prisma.payment.delete({ where: { id } });
        return res.status(204).send();
    }
    catch (error) {
        return res.status(500).json({ error: 'Error al eliminar pago' });
    }
};
exports.deletePayment = deletePayment;
