"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const patientController_1 = require("../controllers/patientController");
const auth_1 = require("../middleware/auth");
const appointmentController_1 = require("../controllers/appointmentController");
const router = express_1.default.Router();
router.use(auth_1.authenticateToken);
router.post('/', patientController_1.createPatient);
router.get('/', patientController_1.getPatients);
router.get('/with-active-appointments', appointmentController_1.getPatientsWithActiveAppointments);
router.get('/:id', patientController_1.getPatientById);
router.put('/:id', patientController_1.updatePatient);
router.delete('/:id', patientController_1.deletePatient);
router.post('/fix-mexican-phones', patientController_1.fixMexicanPhones);
exports.default = router;
