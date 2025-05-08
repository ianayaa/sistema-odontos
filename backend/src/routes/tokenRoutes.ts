import express, { Router, Request, Response } from 'express';
import jwt from 'jsonwebtoken';

const router: Router = express.Router();

router.post('/refresh', (req: Request, res: Response) => {
  const refreshToken = req.cookies?.refreshToken;
  if (!refreshToken) {
    return res.status(401).json({ error: 'No refresh token provided' });
  }
  try {
    const payload = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET!);
    // Opcional: verifica si el usuario existe en la base de datos
    const accessToken = jwt.sign(
      { id: (payload as any).id },
      process.env.JWT_SECRET!,
      { expiresIn: '15m' }
    );
    res.json({ accessToken });
  } catch (err) {
    return res.status(403).json({ error: 'Invalid refresh token' });
  }
});

export default router;
