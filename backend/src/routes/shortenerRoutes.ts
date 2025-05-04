import * as express from 'express';
import { nanoid } from 'nanoid';

const router = express.Router();

// Almacenamiento temporal en memoria (puedes migrar a DB después)
const urlMap: Record<string, string> = {};

// Handler para crear enlace corto
const createShortUrl = (req: express.Request, res: express.Response) => {
  const { url } = req.body;
  if (!url || typeof url !== 'string') {
    res.status(400).json({ error: 'URL inválida' });
    return;
  }
  const code = nanoid(7);
  urlMap[code] = url;
  res.json({ short: `${process.env.SHORTENER_BASE_URL || 'https://odontosdentaloffice.com/s'}/${code}` });
};

// Handler para obtener enlace largo
const getLongUrl = (req: express.Request, res: express.Response) => {
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

export default router; 