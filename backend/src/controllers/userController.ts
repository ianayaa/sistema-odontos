import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';

const prisma = new PrismaClient();

export const createUser = async (req: Request, res: Response) => {
  try {
    const { email, password, name, role } = req.body;
    
    // Verificar si el usuario ya existe
    const existingUser = await prisma.user.findUnique({
      where: { email }
    });

    if (existingUser) {
      res.status(400).json({ error: 'El usuario ya existe' });
    } else {
      // Encriptar contraseña
      const hashedPassword = await bcrypt.hash(password, 10);

      const user = await prisma.user.create({
        data: {
          email,
          password: hashedPassword,
          name,
          role
        }
      });

      res.status(201).json({
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role
      });
    }
  } catch (error) {
    res.status(500).json({ error: 'Error al crear usuario' });
  }
};

export const login = async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;

    const user = await prisma.user.findUnique({
      where: { email }
    });

    if (!user) {
      res.status(401).json({ error: 'Credenciales inválidas' });
    } else {
      const validPassword = await bcrypt.compare(password, user.password);

      if (!validPassword) {
        res.status(401).json({ error: 'Credenciales inválidas' });
      } else {
        const token = jwt.sign(
          { id: user.id, email: user.email, role: user.role },
          process.env.JWT_SECRET!,
          { expiresIn: '24h' }
        );

        res.json({
          token,
          user: {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role
          }
        });
      }
    }
  } catch (error) {
    res.status(500).json({ error: 'Error al iniciar sesión' });
  }
};

export const getUsers = async (req: Request, res: Response) => {
  try {
    const users = await prisma.user.findMany({
      select: {
        id: true,
        email: true,
        name: true,
        role: true,
        createdAt: true
      }
    });
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener usuarios' });
  }
};

export const updateUser = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { name, role } = req.body;

    const user = await prisma.user.update({
      where: { id },
      data: {
        name,
        role
      },
      select: {
        id: true,
        email: true,
        name: true,
        role: true,
        createdAt: true
      }
    });

    res.json(user);
  } catch (error) {
    res.status(500).json({ error: 'Error al actualizar usuario' });
  }
};

export const deleteUser = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    // Verificar si el usuario es ADMIN
    const user = await prisma.user.findUnique({ where: { id } });
    if (user?.role === 'ADMIN') {
      return res.status(403).json({ error: 'No se puede eliminar el usuario administrador.' });
    }
    await prisma.user.delete({
      where: { id }
    });
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: 'Error al eliminar usuario' });
  }
}; 