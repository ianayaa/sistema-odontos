"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const medicalHistoryController_1 = require("../controllers/medicalHistoryController");
const auth_1 = require("../middleware/auth");
const router = express_1.default.Router();
router.use(auth_1.authenticateToken);
router.post('/', medicalHistoryController_1.createMedicalHistory);
router.get('/patient/:patientId', medicalHistoryController_1.getMedicalHistory);
router.put('/patient/:patientId', medicalHistoryController_1.updateMedicalHistory);
router.post('/patient/:patientId/treatment', medicalHistoryController_1.addTreatment);
exports.default = router;
