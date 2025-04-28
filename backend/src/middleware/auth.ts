import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

interface JwtPayload {
  id: string;
  email: string;
  role: string;
}

declare global {
  namespace Express {
    interface Request {
      user?: JwtPayload;
    }
  }
}

export const authenticateToken = (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Token no proporcionado' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET!) as JwtPayload | string;
    // Asegúrate de que req.user siempre sea un objeto con id, email y role
    if (typeof decoded === 'string') {
      return res.status(403).json({ error: 'Token inválido' });
    }
    req.user = {
      id: decoded.id,
      email: decoded.email,
      role: decoded.role
    };
    next();
  } catch (error) {
    return res.status(403).json({ error: 'Token inválido' });
  }
};

export const isAdmin = (req: Request, res: Response, next: NextFunction) => {
  if (!req.user || req.user.role !== 'ADMIN') {
    return res.status(403).json({ error: 'Acceso denegado. Se requieren privilegios de administrador' });
  }
  next();
};

export const isDentist = (req: Request, res: Response, next: NextFunction) => {
  if (!req.user || (req.user.role !== 'DENTIST' && req.user.role !== 'ADMIN')) {
    return res.status(403).json({ error: 'Acceso denegado. Se requieren privilegios de odontólogo' });
  }
  next();
};

export const isAssistant = (req: Request, res: Response, next: NextFunction) => {
  if (!req.user || (req.user.role !== 'ASSISTANT' && req.user.role !== 'ADMIN')) {
    return res.status(403).json({ error: 'Acceso denegado. Se requieren privilegios de asistente' });
  }
  next();
};

export const isPatient = (req: Request, res: Response, next: NextFunction) => {
  if (!req.user || (req.user.role !== 'PATIENT' && req.user.role !== 'ADMIN')) {
    return res.status(403).json({ error: 'Acceso denegado. Se requieren privilegios de paciente' });
  }
  next();
};