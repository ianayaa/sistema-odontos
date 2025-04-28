"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getPaymentSummary = exports.updatePaymentStatus = exports.getPayments = exports.createPayment = void 0;
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
                patient: true
            },
            orderBy: {
                createdAt: 'desc'
            }
        });
        res.json(payments);
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
