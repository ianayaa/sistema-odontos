"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const clinicConfigController_1 = require("../controllers/clinicConfigController");
const router = express_1.default.Router();
router.get('/', clinicConfigController_1.getClinicConfig);
router.put('/', clinicConfigController_1.updateClinicConfig);
exports.default = router;
