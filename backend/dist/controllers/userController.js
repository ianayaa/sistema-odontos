"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getCurrentUser = exports.updateUserActive = exports.deleteUser = exports.updateUser = exports.getUsers = exports.login = exports.createUser = void 0;
const client_1 = require("@prisma/client");
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const prisma = new client_1.PrismaClient();
// Definir permisos por rol
const rolePermissions = {
    ADMIN: [
        'inicio',
        'pacientes',
        'citas',
        'pagos',
        'consentimientos',
        'servicios',
        'reportes',
        'comunicacion',
        'portal_paciente',
        'pagos_odontologos',
        'configuracion'
    ],
    DENTIST: [
        'inicio',
        'pacientes',
        'citas',
        'pagos',
        'consentimientos',
        'servicios',
        'reportes',
        'comunicacion',
        'portal_paciente'
    ],
    ASSISTANT: [
        'inicio',
        'pacientes',
        'citas',
        'pagos',
        'consentimientos',
        'servicios',
        'comunicacion'
    ],
    PATIENT: [
        'inicio',
        'portal_paciente'
    ]
};
const createUser = async (req, res) => {
    try {
        const { email, password, name, lastNamePaterno, lastNameMaterno, role, permissions } = req.body;
        console.log('Datos recibidos:', { email, name, role, permissions });
        // Verificar si el usuario ya existe
        const existingUser = await prisma.user.findUnique({
            where: { email }
        });
        if (existingUser) {
            return res.status(400).json({ error: 'El usuario ya existe' });
        }
        // Encriptar contraseña
        const hashedPassword = await bcryptjs_1.default.hash(password, 10);
        // Crear el usuario primero
        const user = await prisma.user.create({
            data: {
                email,
                password: hashedPassword,
                name,
                lastNamePaterno,
                lastNameMaterno,
                role
            }
        });
        console.log('Usuario creado:', user);
        // Asignar permisos por defecto según el rol si no se proporcionan permisos específicos
        const permissionsToAssign = permissions || rolePermissions[role] || [];
        // Crear los permisos
        if (permissionsToAssign.length > 0) {
            try {
                await prisma.userPermission.createMany({
                    data: permissionsToAssign.map((permissionId) => ({
                        userId: user.id,
                        permissionId
                    }))
                });
                console.log('Permisos creados exitosamente');
            }
            catch (permissionError) {
                console.error('Error al crear permisos:', permissionError);
                // Continuar con la respuesta aunque falle la creación de permisos
            }
        }
        // Obtener el usuario con sus permisos
        const userWithPermissions = await prisma.user.findUnique({
            where: { id: user.id },
            include: {
                permissions: {
                    include: {
                        permission: true
                    }
                }
            }
        });
        console.log('Usuario con permisos:', userWithPermissions);
        res.status(201).json({
            id: userWithPermissions?.id,
            email: userWithPermissions?.email,
            name: userWithPermissions?.name,
            role: userWithPermissions?.role,
            permissions: userWithPermissions?.permissions.map(p => p.permission.id) || []
        });
    }
    catch (error) {
        console.error('Error detallado al crear usuario:', error);
        res.status(500).json({
            error: 'Error al crear usuario',
            details: error instanceof Error ? error.message : 'Error desconocido'
        });
    }
};
exports.createUser = createUser;
const login = async (req, res) => {
    try {
        console.log('=== INICIO DE PROCESO DE LOGIN ===');
        const { email, password, systemType = 'main' } = req.body;
        console.log('Datos recibidos:', { email, systemType });
        console.log('Buscando usuario en la base de datos...');
        const user = await prisma.user.findUnique({
            where: { email },
            include: {
                permissions: {
                    include: {
                        permission: true
                    }
                }
            }
        });
        if (!user) {
            console.log('Usuario no encontrado');
            return res.status(401).json({ error: 'Credenciales inválidas' });
        }
        console.log('Usuario encontrado:', {
            id: user.id,
            email: user.email,
            role: user.role,
            isActive: user.isActive
        });
        // Validar si el usuario está activo
        if (!user.isActive) {
            console.log('Usuario inactivo');
            return res.status(403).json({ error: 'Cuenta desactivada. Contacte al administrador.' });
        }
        // Validar el rol según el sistema
        if (systemType === 'main' && !['ADMIN', 'DENTIST', 'ASSISTANT'].includes(user.role)) {
            console.log('Rol no permitido para sistema principal:', user.role);
            return res.status(403).json({ error: 'Acceso denegado para este usuario' });
        }
        if (systemType === 'patient-portal' && user.role !== 'PATIENT') {
            console.log('Rol no permitido para portal de paciente:', user.role);
            return res.status(403).json({ error: 'Acceso denegado para este usuario' });
        }
        console.log('Validando contraseña...');
        const validPassword = await bcryptjs_1.default.compare(password, user.password);
        if (!validPassword) {
            console.log('Contraseña inválida');
            return res.status(401).json({ error: 'Credenciales inválidas' });
        }
        console.log('Generando token JWT...');
        const token = jsonwebtoken_1.default.sign({ id: user.id, email: user.email, role: user.role }, process.env.JWT_SECRET, { expiresIn: '24h' });
        // Transformar la respuesta para incluir los permisos como un array de strings
        const userWithPermissions = {
            id: user.id,
            email: user.email,
            name: user.name,
            lastNamePaterno: user.lastNamePaterno,
            lastNameMaterno: user.lastNameMaterno,
            role: user.role,
            permissions: user.permissions.map(p => p.permission.id)
        };
        console.log('Login exitoso para usuario:', user.email);
        console.log('=== FIN DE PROCESO DE LOGIN ===');
        res.json({
            token,
            user: userWithPermissions
        });
    }
    catch (error) {
        console.error('Error detallado al iniciar sesión:', error);
        console.error('Stack trace:', error instanceof Error ? error.stack : 'No stack trace available');
        res.status(500).json({
            error: 'Error al iniciar sesión',
            details: error instanceof Error ? error.message : 'Error desconocido'
        });
    }
};
exports.login = login;
const getUsers = async (req, res) => {
    try {
        const users = await prisma.user.findMany({
            select: {
                id: true,
                email: true,
                name: true,
                lastNamePaterno: true,
                lastNameMaterno: true,
                role: true,
                isActive: true,
                createdAt: true,
                permissions: {
                    include: {
                        permission: true
                    }
                }
            }
        });
        // Transformar la respuesta para incluir los permisos como un array de strings
        const usersWithPermissions = users.map(user => ({
            ...user,
            permissions: user.permissions.map(p => p.permission.id)
        }));
        res.json(usersWithPermissions);
    }
    catch (error) {
        console.error('Error al obtener usuarios:', error);
        res.status(500).json({ error: 'Error al obtener usuarios' });
    }
};
exports.getUsers = getUsers;
const updateUser = async (req, res) => {
    try {
        const { id } = req.params;
        const { name, lastNamePaterno, lastNameMaterno, role, permissions } = req.body;
        console.log('Datos de actualización:', { id, name, role, permissions });
        // Actualizar el usuario primero
        const user = await prisma.user.update({
            where: { id },
            data: {
                name,
                lastNamePaterno,
                lastNameMaterno,
                role
            }
        });
        console.log('Usuario actualizado:', user);
        // Eliminar permisos existentes
        await prisma.userPermission.deleteMany({
            where: { userId: id }
        });
        // Crear nuevos permisos si existen
        if (permissions && permissions.length > 0) {
            try {
                await prisma.userPermission.createMany({
                    data: permissions.map((permissionId) => ({
                        userId: id,
                        permissionId
                    }))
                });
                console.log('Permisos actualizados exitosamente');
            }
            catch (permissionError) {
                console.error('Error al actualizar permisos:', permissionError);
                // Continuar con la respuesta aunque falle la actualización de permisos
            }
        }
        // Obtener el usuario actualizado con sus permisos
        const updatedUser = await prisma.user.findUnique({
            where: { id },
            include: {
                permissions: {
                    include: {
                        permission: true
                    }
                }
            }
        });
        console.log('Usuario final con permisos:', updatedUser);
        res.json({
            id: updatedUser?.id,
            email: updatedUser?.email,
            name: updatedUser?.name,
            lastNamePaterno: updatedUser?.lastNamePaterno,
            lastNameMaterno: updatedUser?.lastNameMaterno,
            role: updatedUser?.role,
            permissions: updatedUser?.permissions.map(p => p.permission) || []
        });
    }
    catch (error) {
        console.error('Error detallado al actualizar usuario:', error);
        res.status(500).json({
            error: 'Error al actualizar usuario',
            details: error instanceof Error ? error.message : 'Error desconocido'
        });
    }
};
exports.updateUser = updateUser;
const deleteUser = async (req, res) => {
    try {
        const { id } = req.params;
        // No permitir eliminar el admin principal
        const user = await prisma.user.findUnique({ where: { id } });
        if (user?.role === 'ADMIN') {
            return res.status(403).json({ error: 'No se puede eliminar el usuario administrador.' });
        }
        // Buscar pacientes relacionados
        const patients = await prisma.patient.findMany({ where: { userId: id } });
        for (const patient of patients) {
            await prisma.appointment.deleteMany({ where: { patientId: patient.id } });
            await prisma.payment.deleteMany({ where: { patientId: patient.id } });
            await prisma.consultation.deleteMany({ where: { patientId: patient.id } });
            await prisma.medicalHistory.deleteMany({ where: { patientId: patient.id } });
            await prisma.odontogram.deleteMany({ where: { patientId: patient.id } });
            await prisma.patient.delete({ where: { id: patient.id } });
        }
        // Ahora sí, eliminar el usuario
        await prisma.user.delete({ where: { id } });
        res.status(204).send();
    }
    catch (error) {
        res.status(500).json({ error: 'Error al eliminar usuario y sus datos relacionados' });
    }
};
exports.deleteUser = deleteUser;
const updateUserActive = async (req, res) => {
    try {
        const { id } = req.params;
        const { isActive } = req.body;
        const user = await prisma.user.update({
            where: { id },
            data: { isActive }
        });
        res.json(user);
    }
    catch (error) {
        res.status(500).json({ error: 'Error al actualizar estado del usuario' });
    }
};
exports.updateUserActive = updateUserActive;
const getCurrentUser = async (req, res) => {
    try {
        const userId = req.user?.id;
        if (!userId) {
            return res.status(401).json({ error: 'No autorizado' });
        }
        const user = await prisma.user.findUnique({
            where: { id: userId },
            select: {
                id: true,
                email: true,
                name: true,
                lastNamePaterno: true,
                lastNameMaterno: true,
                role: true,
                isActive: true,
                createdAt: true,
                permissions: {
                    include: {
                        permission: true
                    }
                }
            }
        });
        if (!user) {
            return res.status(404).json({ error: 'Usuario no encontrado' });
        }
        // Transformar la respuesta para incluir los permisos como un array de strings
        const userWithPermissions = {
            ...user,
            permissions: user.permissions.map(p => p.permission.id)
        };
        res.json(userWithPermissions);
    }
    catch (error) {
        console.error('Error al obtener usuario actual:', error);
        res.status(500).json({ error: 'Error al obtener usuario actual' });
    }
};
exports.getCurrentUser = getCurrentUser;
