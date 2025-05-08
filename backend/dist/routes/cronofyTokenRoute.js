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
router.post('/', async (req, res) => {
    try {
        // 1. Consigue un access_token OAuth2
        const auth = Buffer.from(`${process.env.CRONOFY_CLIENT_ID}:${process.env.CRONOFY_CLIENT_SECRET}`).toString('base64');
        const tokenRes = await axios_1.default.post('https://api.cronofy.com/oauth/token', {
            grant_type: 'client_credentials',
            scope: 'read_account read_events create_event',
        }, {
            headers: { Authorization: `Basic ${auth}` }
        });
        const accessToken = tokenRes.data.access_token;
        // 2. Crea el Element Token
        const elementRes = await axios_1.default.post('https://api.cronofy.com/v1/ui_element_tokens', {
            permissions: ['availability', 'read_events', 'create_event'],
            // Puedes agregar más opciones aquí si lo necesitas
        }, {
            headers: { Authorization: `Bearer ${accessToken}` }
        });
        res.json({ element_token: elementRes.data.element_token });
    }
    catch (error) {
        console.error('CRONOFY ERROR:', error?.response?.data || error.message || error);
        res.status(500).json({ error: error.message, details: error.response?.data });
    }
});
exports.default = router;
