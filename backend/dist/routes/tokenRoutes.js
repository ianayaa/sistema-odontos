"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const router = express_1.default.Router();
router.post('/refresh', (req, res) => {
    const refreshToken = req.cookies?.refreshToken;
    if (!refreshToken) {
        return res.status(401).json({ error: 'No refresh token provided' });
    }
    try {
        const payload = jsonwebtoken_1.default.verify(refreshToken, process.env.JWT_REFRESH_SECRET);
        // Opcional: verifica si el usuario existe en la base de datos
        const accessToken = jsonwebtoken_1.default.sign({ id: payload.id }, process.env.JWT_SECRET, { expiresIn: '15m' });
        res.json({ accessToken });
    }
    catch (err) {
        return res.status(403).json({ error: 'Invalid refresh token' });
    }
});
exports.default = router;
