"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const axios_1 = __importDefault(require("axios"));
const dotenv_1 = __importDefault(require("dotenv"));
dotenv_1.default.config();
const router = express_1.default.Router();
// 1. Redirige al usuario a Cronofy para autorizar
router.get('/authorize', (req, res) => {
    const redirectUri = encodeURIComponent(process.env.CRONOFY_REDIRECT_URI || 'http://localhost:3000/api/cronofy-oauth/callback');
    const clientId = process.env.CRONOFY_CLIENT_ID;
    const scope = 'read_write';
    const url = `https://auth.cronofy.com/oauth/authorize?client_id=${clientId}&redirect_uri=${redirectUri}&response_type=code&scope=${scope}`;
    res.redirect(url);
});
// 2. Recibe el code y pide el access_token
router.get('/callback', async (req, res) => {
    const code = req.query.code;
    const redirectUri = process.env.CRONOFY_REDIRECT_URI || 'http://localhost:3000/api/cronofy-oauth/callback';
    try {
        const tokenRes = await axios_1.default.post('https://api.cronofy.com/oauth/token', {
            grant_type: 'authorization_code',
            client_id: process.env.CRONOFY_CLIENT_ID,
            client_secret: process.env.CRONOFY_CLIENT_SECRET,
            redirect_uri: redirectUri,
            code,
        });
        // Aquí puedes guardar el access_token en tu base de datos asociado al usuario
        // Ejemplo: req.session.access_token = tokenRes.data.access_token;
        res.json({ message: 'Autorización exitosa', tokens: tokenRes.data });
    }
    catch (error) {
        console.error('CRONOFY OAUTH ERROR:', error?.response?.data || error.message || error);
        res.status(500).json({ error: error.message, details: error.response?.data });
    }
});
exports.default = router;
