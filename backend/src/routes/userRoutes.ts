import express, { Request, Response } from 'express';
import {
  createUser,
  login,
  getUsers,
  updateUser,
  deleteUser,
  getCurrentUser
} from '../controllers/userController';
import { authenticateToken, isAdmin } from '../middleware/auth';

const router = express.Router();

// Rutas públicas
router.post('/login', wrapAsync(login));

// Rutas protegidas
router.use(authenticateToken);
router.get('/me', wrapAsync(getCurrentUser));
router.get('/', wrapAsync(getUsers));
router.post('/', wrapAsync(createUser));
router.put('/:id', wrapAsync(updateUser));
router.delete('/:id', wrapAsync(deleteUser));

// Rutas de administración
router.use(isAdmin);

function wrapAsync(fn: (req: Request, res: Response) => Promise<any>) {
  return (req: Request, res: Response, next: express.NextFunction) => {
    Promise.resolve(fn(req, res)).catch(next);
  };
}

export default router;