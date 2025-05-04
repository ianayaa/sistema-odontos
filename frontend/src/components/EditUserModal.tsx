import React, { useState, useEffect } from 'react';
import { UserCircle, X } from 'phosphor-react';
import RoleSelect from './RoleSelect';

interface Props {
  open: boolean;
  onClose: () => void;
  user: {
    id: string;
    name: string;
    lastNamePaterno?: string;
    lastNameMaterno?: string;
    email: string;
    role: string;
    permissions?: string[];
  } | null;
  onEdit: (data: { id: string; name: string; lastNamePaterno: string; lastNameMaterno: string; email: string; role: string; permissions: string[] }) => void;
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
  DOCTOR: ['inicio', 'pacientes', 'citas', 'pagos', 'consentimientos', 'servicios', 'reportes', 'pagos_odontologos'],
  RECEPCIONISTA: ['inicio', 'pacientes', 'citas', 'pagos', 'servicios', 'reportes'],
  // Agrega más roles según tu sistema
};

const EditUserModal: React.FC<Props> = ({ open, onClose, user, onEdit }) => {
  const [form, setForm] = useState({ id: '', name: '', lastNamePaterno: '', lastNameMaterno: '', email: '', role: 'ADMIN', permissions: sectionPermissions.map(s => s.key) });

  useEffect(() => {
    if (user) {
      setForm({
        id: user.id,
        name: user.name,
        lastNamePaterno: user.lastNamePaterno || '',
        lastNameMaterno: user.lastNameMaterno || '',
        email: user.email,
        role: user.role,
        permissions: user.permissions || sectionPermissions.map(s => s.key),
      });
    }
  }, [user]);

  if (!open || !user) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onEdit(form);
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

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
      <div className="bg-white rounded-3xl shadow-2xl w-full max-w-lg p-0 relative overflow-hidden animate-fadeInUp">
        <div className="flex items-center gap-3 bg-gradient-to-r from-red-100 to-red-50 px-8 py-6 border-b border-red-100">
          <div className="bg-red-200 text-red-600 rounded-full p-3">
            <UserCircle size={30} weight="duotone" />
          </div>
          <div className="flex-1">
            <h3 className="text-xl font-bold text-gray-800">Editar Usuario</h3>
            <div className="text-gray-400 text-sm">Modifica los datos y permisos del usuario</div>
          </div>
          <button
            className="ml-auto text-gray-400 hover:text-red-600 text-2xl font-bold p-1 rounded-full transition-colors focus:outline-none"
            onClick={onClose}
            aria-label="Cerrar"
            type="button"
          >
            <X size={28} className="text-red-400 hover:text-red-600" />
          </button>
        </div>
        <form onSubmit={handleSubmit} className="px-8 py-7 space-y-4">
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
          <div className="flex gap-4">
            <div className="flex-1">
              <label className="block text-sm font-medium text-gray-700 mb-1">Apellido paterno</label>
              <input
                type="text"
                className="w-full border border-gray-200 rounded-xl px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
                value={form.lastNamePaterno}
                onChange={e => setForm({ ...form, lastNamePaterno: e.target.value })}
                required
              />
            </div>
            <div className="flex-1">
              <label className="block text-sm font-medium text-gray-700 mb-1">Apellido materno</label>
              <input
                type="text"
                className="w-full border border-gray-200 rounded-xl px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
                value={form.lastNameMaterno}
                onChange={e => setForm({ ...form, lastNameMaterno: e.target.value })}
                required
              />
            </div>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
            <input
              type="email"
              className="w-full border border-gray-200 rounded-xl px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
              value={form.email}
              onChange={e => setForm({ ...form, email: e.target.value })}
              required
            />
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
            <div className="grid grid-cols-2 gap-2">
              {sectionPermissions.map(perm => (
                <label key={perm.key} className="flex items-center gap-2 text-gray-700 text-sm font-normal">
                  <input
                    type="checkbox"
                    checked={form.permissions.includes(perm.key)}
                    onChange={() => handleCheckboxChange(perm.key)}
                    className="rounded border-gray-300 focus:ring-red-400"
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
            Guardar cambios
          </button>
        </form>
      </div>
    </div>
  );
};

export default EditUserModal;
