import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { PrismaClient } from '@prisma/client';

interface JwtPayload {
  id: string;
  email: string;
  role: string;
}

interface UserPermissionWithPermission {
  id: string;
  userId: string;
  permissionId: string;
  permission: {
    id: string;
    name: string;
    description: string;
  };
}

declare global {
  namespace Express {
    interface Request {
      user?: JwtPayload;
    }
  }
}

const prisma = new PrismaClient();

export const authenticateToken = (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    res.status(401).json({ error: 'Token no proporcionado' });
    return;
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET!) as JwtPayload | string;
    // Asegúrate de que req.user siempre sea un objeto con id, email y role
    if (typeof decoded === 'string') {
      res.status(403).json({ error: 'Token inválido' });
      return;
    }
    req.user = {
      id: decoded.id,
      email: decoded.email,
      role: decoded.role
    };
    next();
  } catch (error) {
    res.status(403).json({ error: 'Token inválido' });
    return;
  }
};

export const isAdmin = (req: Request, res: Response, next: NextFunction) => {
  if (!req.user || req.user.role !== 'ADMIN') {
    res.status(403).json({ error: 'Acceso denegado. Se requieren privilegios de administrador' });
    return;
  }
  next();
};

export const isDentist = (req: Request, res: Response, next: NextFunction) => {
  if (!req.user || (req.user.role !== 'DENTIST' && req.user.role !== 'ADMIN')) {
    res.status(403).json({ error: 'Acceso denegado. Se requieren privilegios de odontólogo' });
    return;
  }
  next();
};

export const isAssistant = (req: Request, res: Response, next: NextFunction) => {
  if (!req.user || (req.user.role !== 'ASSISTANT' && req.user.role !== 'ADMIN')) {
    res.status(403).json({ error: 'Acceso denegado. Se requieren privilegios de asistente' });
    return;
  }
  next();
};

export const isPatient = (req: Request, res: Response, next: NextFunction) => {
  if (!req.user || (req.user.role !== 'PATIENT' && req.user.role !== 'ADMIN')) {
    res.status(403).json({ error: 'Acceso denegado. Se requieren privilegios de paciente' });
    return;
  }
  next();
};

export const hasPermission = (requiredPermission: string) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) {
      res.status(401).json({ error: 'No autenticado' });
      return;
    }

    try {
      const userPermissions = await prisma.userPermission.findMany({
        where: { userId: req.user.id },
        include: { permission: true }
      });

      const hasPermission = userPermissions.some(
        (up: UserPermissionWithPermission) => up.permission.name === requiredPermission
      );

      if (!hasPermission) {
        res.status(403).json({ error: 'No tiene permiso para realizar esta acción' });
        return;
      }

      next();
    } catch (error) {
      res.status(500).json({ error: 'Error al verificar permisos' });
    }
  };
};