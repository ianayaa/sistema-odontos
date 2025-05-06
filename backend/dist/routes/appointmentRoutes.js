"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const appointmentController_1 = require("../controllers/appointmentController");
const auth_1 = require("../middleware/auth");
const router = express_1.default.Router();
// Ruta pública para confirmar cita
router.post('/:id/confirm', wrapAsync(appointmentController_1.publicConfirmAppointment));
router.use(auth_1.authenticateToken);
router.post('/', wrapAsync(appointmentController_1.createAppointment));
router.get('/', wrapAsync(appointmentController_1.getAppointments));
router.put('/:id', wrapAsync(appointmentController_1.updateAppointment));
router.post('/:id/cancel', wrapAsync(appointmentController_1.cancelAppointment));
router.get('/patient/:patientId', wrapAsync(appointmentController_1.getPatientAppointments));
router.delete('/:id', wrapAsync(appointmentController_1.deleteAppointment));
// Nueva ruta para notificar cambio de cita
router.post('/:id/notify', wrapAsync(appointmentController_1.notifyAppointmentChange));
// Rutas para configuración de horarios/bloqueos del dentista autenticado
router.get('/schedule', auth_1.isDentist, wrapAsync(appointmentController_1.getDentistSchedule));
router.post('/schedule', auth_1.isDentist, wrapAsync(appointmentController_1.upsertDentistSchedule));
function wrapAsync(fn) {
    return function (req, res, next) {
        Promise.resolve(fn(req, res, next)).catch(next);
    };
}
exports.default = router;
