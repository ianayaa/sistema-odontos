"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const paymentController_1 = require("../controllers/paymentController");
const auth_1 = require("../middleware/auth");
const router = express_1.default.Router();
router.use(auth_1.authenticateToken);
router.post('/', paymentController_1.createPayment);
router.get('/', paymentController_1.getPayments);
router.put('/:id/status', paymentController_1.updatePaymentStatus);
router.get('/summary', paymentController_1.getPaymentSummary);
router.post('/dentist', paymentController_1.createDentistPayment);
router.get('/dentist', paymentController_1.getDentistPayments);
router.get('/dentist/summary', paymentController_1.getDentistPaymentsSummary);
exports.default = router;
