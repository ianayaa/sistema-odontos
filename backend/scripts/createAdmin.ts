import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  const email = 'admin@odontos.com';
  const password = 'Admin123!';
  const hashedPassword = await bcrypt.hash(password, 10);
  const name = 'Administrador';
  try {
    const admin = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        name,
        role: 'ADMIN',
        isActive: true
      }
    });
    console.log('Usuario administrador creado:', admin);
  } catch (error) {
    console.error('Error al crear el usuario administrador:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main(); 