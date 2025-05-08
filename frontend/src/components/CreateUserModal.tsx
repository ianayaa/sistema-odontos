import React, { useState, useEffect } from 'react';
import { User, Eye, EyeSlash, UserCircle, Shield, FirstAid, UserGear, User as UserIcon, UserPlus, X } from 'phosphor-react';
import RoleSelect from './RoleSelect';
import ReactDOM from 'react-dom';

interface Props {
  open: boolean;
  onClose: () => void;
  onCreate: (data: { name: string; lastNamePaterno: string; lastNameMaterno: string; email: string; password: string; role: string }) => void;
}

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
  DENTIST: ['inicio', 'pacientes', 'citas', 'pagos', 'consentimientos', 'servicios', 'reportes', 'pagos_odontologos'],
  ASSISTANT: ['inicio', 'pacientes', 'citas', 'pagos', 'servicios', 'reportes'],
};

const CreateUserModal: React.FC<Props> = ({ open, onClose, onCreate }) => {
  const [form, setForm] = useState({
    name: '',
    lastNamePaterno: '',
    lastNameMaterno: '',
    email: '',
    password: '',
    role: 'ADMIN',
    permissions: roleDefaultPermissions['ADMIN'],
  });
  const [showPassword, setShowPassword] = useState(false);
  const [passwordStrength, setPasswordStrength] = useState<'débil' | 'media' | 'fuerte' | null>(null);

  // Password criteria definition moved before useEffect
  const passwordCriteria = [
    { label: 'Al menos 8 caracteres', test: (pw: string) => pw.length >= 8 },
    { label: 'Una letra mayúscula', test: (pw: string) => /[A-Z]/.test(pw) },
    { label: 'Una letra minúscula', test: (pw: string) => /[a-z]/.test(pw) },
    { label: 'Un número', test: (pw: string) => /[0-9]/.test(pw) },
    { label: 'Un símbolo', test: (pw: string) => /[^A-Za-z0-9]/.test(pw) },
  ];

  const validatePassword = () => {
    const pw: string = form.password;
    const passed = passwordCriteria.filter(c => c.test(pw)).length;
    if (!pw) setPasswordStrength(null);
    else if (passed <= 2) setPasswordStrength('débil');
    else if (passed === 3 || passed === 4) setPasswordStrength('media');
    else setPasswordStrength('fuerte');
  };

  useEffect(() => {
    validatePassword();
  }, [form.password]);

  useEffect(() => {
    if (open) {
      setForm(prev => ({
        ...prev,
        permissions: roleDefaultPermissions[prev.role] || [],
      }));
    }
  }, [open]);

  if (!open) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onCreate(form);
    setForm({
      name: '',
      lastNamePaterno: '',
      lastNameMaterno: '',
      email: '',
      password: '',
      role: 'ADMIN',
      permissions: roleDefaultPermissions['ADMIN'],
    });
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

  const modalContent = (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
      <div className="bg-white rounded-3xl shadow-2xl w-full max-w-2xl p-0 relative overflow-hidden animate-fadeInUp">
        <div className="flex items-center gap-3 bg-gradient-to-r from-red-100 to-red-50 px-8 py-6 border-b border-red-100">
          <div className="bg-red-200 text-red-600 rounded-full p-3">
            <UserPlus size={30} className="text-red-500" />
          </div>
          <div className="flex-1">
            <h3 className="text-xl font-bold text-gray-800">Nuevo Usuario</h3>
            <div className="text-gray-400 text-sm">Completa los datos para crear un nuevo usuario</div>
          </div>
          <button
            className="ml-auto text-gray-400 hover:text-red-600 text-2xl font-bold p-1 rounded-full transition-colors focus:outline-none"
            onClick={onClose}
            aria-label="Cerrar"
            type="button"
          >
            <svg width="28" height="28" fill="none" stroke="#d32f2f" strokeWidth="2.2" viewBox="0 0 24 24">
              <circle cx="12" cy="12" r="10" />
              <path d="M15 9l-6 6M9 9l6 6" />
            </svg>
          </button>
        </div>

        <form onSubmit={handleSubmit} className="px-8 py-7 space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Nombre</label>
              <input
                type="text"
                className="w-full border border-gray-200 rounded-xl px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
                value={form.name}
                onChange={e => setForm({ ...form, name: e.target.value })}
                required
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Apellido Paterno</label>
              <input
                type="text"
                className="w-full border border-gray-200 rounded-xl px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
                value={form.lastNamePaterno}
                onChange={e => setForm({ ...form, lastNamePaterno: e.target.value })}
                required
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Apellido Materno</label>
              <input
                type="text"
                className="w-full border border-gray-200 rounded-xl px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
                value={form.lastNameMaterno}
                onChange={e => setForm({ ...form, lastNameMaterno: e.target.value })}
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Correo electrónico</label>
              <input
                type="email"
                className="w-full border border-gray-200 rounded-xl px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
                value={form.email}
                onChange={e => setForm({ ...form, email: e.target.value })}
                required
              />
            </div>
            <div className="col-span-2">
              <label className="block text-sm font-medium text-gray-700 mb-1">Contraseña</label>
              <div className="relative">
                <input
                  type={showPassword ? "text" : "password"}
                  className="w-full border border-gray-200 rounded-xl px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400 pr-10"
                  value={form.password}
                  onChange={e => setForm({ ...form, password: e.target.value })}
                  required
                />
                <button
                  type="button"
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-red-600"
                  onClick={() => setShowPassword(!showPassword)}
                >
                  {showPassword ? <EyeSlash size={20} /> : <Eye size={20} />}
                </button>
              </div>
              {form.password && (
                <div className="mt-2">
                  <div className="text-sm text-gray-500 mb-1">Fortaleza de la contraseña: <span className={`font-semibold ${
                    passwordStrength === 'fuerte' ? 'text-green-600' :
                    passwordStrength === 'media' ? 'text-yellow-600' :
                    'text-red-600'
                  }`}>{passwordStrength}</span></div>
                  <ul className="grid grid-cols-2 gap-x-4 gap-y-1 text-sm">
                    {passwordCriteria.map((criterion, index) => (
                      <li key={index} className="flex items-center gap-2">
                        <span className={`w-4 h-4 rounded-full flex items-center justify-center ${
                          criterion.test(form.password) ? 'bg-green-100 text-green-600' : 'bg-gray-100 text-gray-400'
                        }`}>
                          {criterion.test(form.password) ? '✓' : '×'}
                        </span>
                        <span className={criterion.test(form.password) ? 'text-green-600' : 'text-gray-500'}>
                          {criterion.label}
                        </span>
                      </li>
                    ))}
                  </ul>
                </div>
              )}
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Rol</label>
            <RoleSelect
              value={form.role}
              onChange={role => setForm({
                ...form,
                role,
                permissions: roleDefaultPermissions[role] || [],
              })}
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Permisos de acceso</label>
            <div className="grid grid-cols-2 gap-y-2 gap-x-8">
              {sectionPermissions.map(perm => (
                <label key={perm.key} className="flex items-center gap-2 text-gray-700 text-sm font-normal">
                  <input
                    type="checkbox"
                    checked={form.permissions.includes(perm.key)}
                    onChange={() => handleCheckboxChange(perm.key)}
                    className="accent-blue-500 rounded border-gray-300 focus:ring-blue-400"
                  />
                  {perm.label}
                </label>
              ))}
            </div>
          </div>

          <button
            type="submit"
            className="w-full bg-gradient-to-r from-red-600 to-red-500 hover:from-red-700 hover:to-red-600 text-white font-bold py-2 px-4 rounded-xl transition-all duration-200 shadow-md text-base flex items-center justify-center gap-2"
          >
            <UserPlus size={20} />
            Crear Usuario
          </button>
        </form>
      </div>
    </div>
  );

  return ReactDOM.createPortal(modalContent, document.body);
};

export default CreateUserModal;