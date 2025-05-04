"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
const express = __importStar(require("express"));
const nanoid_1 = require("nanoid");
const router = express.Router();
// Almacenamiento temporal en memoria (puedes migrar a DB después)
const urlMap = {};
// Handler para crear enlace corto
const createShortUrl = (req, res) => {
    const { url } = req.body;
    if (!url || typeof url !== 'string') {
        res.status(400).json({ error: 'URL inválida' });
        return;
    }
    const code = (0, nanoid_1.nanoid)(7);
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
