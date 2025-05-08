"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const userController_1 = require("../controllers/userController");
const auth_1 = require("../middleware/auth");
const router = express_1.default.Router();
// Rutas públicas
router.post('/login', wrapAsync(userController_1.login));
// Rutas protegidas
router.use(auth_1.authenticateToken);
router.get('/me', wrapAsync(userController_1.getCurrentUser));
router.get('/', wrapAsync(userController_1.getUsers));
router.post('/', wrapAsync(userController_1.createUser));
router.put('/:id', wrapAsync(userController_1.updateUser));
router.delete('/:id', wrapAsync(userController_1.deleteUser));
// Rutas de administración
router.use(auth_1.isAdmin);
function wrapAsync(fn) {
    return (req, res, next) => {
        Promise.resolve(fn(req, res)).catch(next);
    };
}
exports.default = router;
