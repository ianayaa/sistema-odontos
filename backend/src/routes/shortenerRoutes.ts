import express from 'express';
import { nanoid } from 'nanoid';

const router = express.Router();

// Almacenamiento temporal en memoria (puedes migrar a DB después)
const urlMap: Record<string, string> = {};

// Crear enlace corto
router.post('/', (req, res) => {
  const { url } = req.body;
  if (!url || typeof url !== 'string') {
    return res.status(400).json({ error: 'URL inválida' });
  }
  const code = nanoid(7);
  urlMap[code] = url;
  res.json({ short: `${process.env.SHORTENER_BASE_URL || 'https://odontosdentaloffice.com/s'}/${code}` });
});

// Redireccionar enlace corto
router.get('/:code', (req, res) => {
  const { code } = req.params;
  const url = urlMap[code];
  if (!url) {
    return res.status(404).send('Enlace no encontrado');
  }
  res.redirect(url);
});

export default router; 