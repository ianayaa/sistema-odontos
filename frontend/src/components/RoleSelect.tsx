import React from 'react';
import { Shield, FirstAid, UserGear, User as UserIcon } from 'phosphor-react';

interface RoleSelectProps {
  value: string;
  onChange: (role: string) => void;
  disabled?: boolean;
}

const options = [
  { value: 'ADMIN', label: 'Administrador', icon: <Shield size={17} className="text-red-500" weight="duotone" /> },
  { value: 'DENTIST', label: 'Dentista', icon: <FirstAid size={17} className="text-blue-500" weight="duotone" /> },
  { value: 'ASSISTANT', label: 'Asistente', icon: <UserGear size={17} className="text-gray-500" weight="duotone" /> },
  { value: 'PATIENT', label: 'Paciente', icon: <UserIcon size={17} className="text-green-500" weight="duotone" /> },
];

const RoleSelect: React.FC<RoleSelectProps> = ({ value, onChange, disabled }) => {
  const [open, setOpen] = React.useState(false);
  const selected = options.find(o => o.value === value);

  return (
    <div className="relative">
      <button
        type="button"
        className={`w-full flex items-center gap-2 border border-gray-200 rounded-xl px-3 pr-10 py-2 bg-white text-gray-700 focus:border-red-400 focus:ring-2 focus:ring-red-100 shadow-sm transition-all hover:border-red-300 ${disabled ? 'opacity-60 cursor-not-allowed' : 'cursor-pointer'}`}
        onClick={() => !disabled && setOpen(o => !o)}
        disabled={disabled}
        aria-haspopup="listbox"
        aria-expanded={open}
      >
        {selected?.icon}
        <span className={`flex-1 text-left ${selected ? '' : 'text-gray-400'}`}>{selected?.label || 'Rol del usuario'}</span>
        <svg className="absolute right-3 top-1/2 -translate-y-1/2 text-red-300" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2.2" viewBox="0 0 24 24"><path d="M6 9l6 6 6-6" /></svg>
      </button>
      {open && (
        <ul className="absolute z-30 mt-2 w-full bg-white rounded-xl shadow-xl border border-gray-100 max-h-56 overflow-y-auto animate-fadeInUp" tabIndex={-1} role="listbox">
          {options.map(opt => (
            <li
              key={opt.value}
              className={`px-4 py-2 hover:bg-red-50 cursor-pointer flex items-center gap-2 ${opt.value === value ? 'bg-red-100 font-semibold text-red-700' : ''}`}
              onClick={() => {
                onChange(opt.value);
                setOpen(false);
              }}
              role="option"
              aria-selected={opt.value === value}
            >
              {opt.icon}
              {opt.label}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

export default RoleSelect;
