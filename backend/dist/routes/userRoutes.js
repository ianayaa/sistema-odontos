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
router.post('/login', userController_1.login);
// Endpoint para validar token y obtener usuario actual (debe ser /me)
router.get('/me', auth_1.authenticateToken, (req, res) => {
    if (!req.user) {
        res.status(401).json({ error: 'No autenticado' });
        return;
    }
    res.json(req.user);
    return;
});
// Rutas protegidas
router.use(auth_1.authenticateToken);
// Rutas de administración
router.use(auth_1.isAdmin);
router.post('/', userController_1.createUser);
router.get('/', userController_1.getUsers);
router.put('/:id', userController_1.updateUser);
router.delete('/:id', userController_1.deleteUser);
exports.default = router;
