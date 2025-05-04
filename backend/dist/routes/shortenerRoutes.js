"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const non_secure_1 = require("nanoid/non-secure");
const router = express_1.default.Router();
// Almacenamiento temporal en memoria (puedes migrar a DB después)
const urlMap = {};
// Handler para crear enlace corto
const createShortUrl = (req, res) => {
    const { url } = req.body;
    if (!url || typeof url !== 'string') {
        res.status(400).json({ error: 'URL inválida' });
        return;
    }
    const code = (0, non_secure_1.nanoid)(7);
    urlMap[code] = url;
    res.json({ short: `${process.env.SHORTENER_BASE_URL || 'https://odontosdentaloffice.com/s'}/${code}` });
};
// Handler para obtener enlace largo
const getLongUrl = (req, res) => {
    const { code } = req.params;
    const url = urlMap[code];
    if (!url) {
        res.status(404).json({ error: 'No encontrado' });
        return;
    }
    res.redirect(url);
};
router.post('/', createShortUrl);
router.get('/:code', getLongUrl);
exports.default = router;
