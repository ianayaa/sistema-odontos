import React, { useState, useEffect } from 'react';
import { User, Eye, EyeSlash, UserCircle, Shield, FirstAid, UserGear, User as UserIcon, UserPlus, X } from 'phosphor-react';
import RoleSelect from './RoleSelect';

interface Props {
  open: boolean;
  onClose: () => void;
  onCreate: (data: { name: string; lastNamePaterno: string; lastNameMaterno: string; email: string; password: string; role: string }) => void;
}

const CreateUserModal: React.FC<Props> = ({ open, onClose, onCreate }) => {
  const [form, setForm] = useState({ name: '', lastNamePaterno: '', lastNameMaterno: '', email: '', password: '', role: 'ADMIN', permissions: ['inicio', 'pacientes', 'citas', 'pagos', 'consentimientos', 'servicios', 'reportes', 'comunicacion', 'portal_paciente', 'pagos_odontologos', 'configuracion'] });
  const [showPassword, setShowPassword] = useState(false);
  const [passwordStrength, setPasswordStrength] = useState<'débil' | 'media' | 'fuerte' | null>(null);

  const sectionPermissions = [
    { key: 'inicio', label: 'Inicio' },
    { key: 'pacientes', label: 'Pacientes' },
    { key: 'citas', label: 'Citas' },
    { key: 'pagos', label: 'Pagos' },
    { key: 'consentimientos', label: 'Consentimientos' },
    { key: 'servicios', label: 'Servicios' },
    { key: 'reportes', label: 'Reportes' },
    { key: 'comunicacion', label: 'Comunicación' },
    { key: 'portal_paciente', label: 'Portal Paciente' },
    { key: 'pagos_odontologos', label: 'Pagos Odontólogos' },
    { key: 'configuracion', label: 'Configuración' },
  ];

  const roleDefaultPermissions: Record<string, string[]> = {
    ADMIN: sectionPermissions.map(s => s.key),
    DOCTOR: ['inicio', 'pacientes', 'citas', 'pagos', 'consentimientos', 'servicios', 'reportes', 'pagos_odontologos'],
    RECEPCIONISTA: ['inicio', 'pacientes', 'citas', 'pagos', 'servicios', 'reportes'],
  };

  // Password strength logic
  const passwordCriteria = [
    { label: 'Al menos 8 caracteres', test: (pw: string) => pw.length >= 8 },
    { label: 'Una letra mayúscula', test: (pw: string) => /[A-Z]/.test(pw) },
    { label: 'Una letra minúscula', test: (pw: string) => /[a-z]/.test(pw) },
    { label: 'Un número', test: (pw: string) => /[0-9]/.test(pw) },
    { label: 'Un símbolo', test: (pw: string) => /[^A-Za-z0-9]/.test(pw) },
  ];

  useEffect(() => {
    validatePassword();
  }, [form.password, passwordCriteria]);

  if (!open) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onCreate(form);
    setForm({ name: '', lastNamePaterno: '', lastNameMaterno: '', email: '', password: '', role: 'ADMIN', permissions: ['inicio', 'pacientes', 'citas', 'pagos', 'consentimientos', 'servicios', 'reportes', 'comunicacion', 'portal_paciente', 'pagos_odontologos', 'configuracion'] });
  };

  const handleCheckboxChange = (key: string) => {
    setForm(prev => {
      const exists = prev.permissions.includes(key);
      return {
        ...prev,
        permissions: exists
          ? prev.permissions.filter(p => p !== key)
          : [...prev.permissions, key],
      };
    });
  };

  const validatePassword = () => {
    const pw: string = form.password;
    const passed = passwordCriteria.filter(c => c.test(pw)).length;
    if (!pw) setPasswordStrength(null);
    else if (passed <= 2) setPasswordStrength('débil');
    else if (passed === 3 || passed === 4) setPasswordStrength('media');
    else setPasswordStrength('fuerte');
  };

  return (
    <div>
      {/* Render your component content here */}
    </div>
  );
};

export default CreateUserModal;