import express from 'express';
import {
  createUser,
  login,
  getUsers,
  updateUser,
  deleteUser
} from '../controllers/userController';
import { authenticateToken, isAdmin } from '../middleware/auth';
import { Request, Response } from 'express';

const router = express.Router();

// Rutas públicas
router.post('/login', login as any);

// Endpoint para validar token y obtener usuario actual (debe ser /me)
router.get('/me', authenticateToken as any, (req: Request, res: Response) => {
  if (!req.user) {
    res.status(401).json({ error: 'No autenticado' });
    return;
  }
  res.json(req.user);
  return;
});

// Rutas protegidas
router.use(authenticateToken as any);

// Rutas de administración
router.use(isAdmin as any);
router.post('/', wrapAsync(createUser));
router.get('/', wrapAsync(getUsers));
router.put('/:id', wrapAsync(updateUser));
router.delete('/:id', wrapAsync(deleteUser));

function wrapAsync(fn: any) {
  return function(req: any, res: any, next: any) {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
}

export default router;