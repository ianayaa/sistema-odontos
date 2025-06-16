import React, { useState } from 'react';
import { Calendar } from 'phosphor-react';

export const dayOptions = [
  { value: 0, label: 'Domingo' },
  { value: 1, label: 'Lunes' },
  { value: 2, label: 'Martes' },
  { value: 3, label: 'Miércoles' },
  { value: 4, label: 'Jueves' },
  { value: 5, label: 'Viernes' },
  { value: 6, label: 'Sábado' },
];

interface DaySelectProps {
  value: number;
  onChange: (v: number) => void;
}

const DaySelect: React.FC<DaySelectProps> = ({ value, onChange }) => {
  const [open, setOpen] = useState(false);
  const selected = dayOptions.find(d => d.value === value);
  return (
    <div className="relative">
      <button
        type="button"
        className="w-full flex items-center gap-2 border border-gray-200 rounded-xl px-3 pr-10 py-2 bg-white text-gray-700 focus:border-yellow-400 focus:ring-2 focus:ring-yellow-100 shadow-sm transition-all hover:border-yellow-300 cursor-pointer"
        onClick={() => setOpen(o => !o)}
        aria-haspopup="listbox"
        aria-expanded={open}
      >
        <Calendar size={18} className="text-yellow-400" />
        <span className={`flex-1 text-left ${selected ? '' : 'text-gray-400'}`}>{selected ? selected.label : 'Selecciona un día'}</span>
        <svg className="absolute right-3 top-1/2 -translate-y-1/2 text-yellow-300" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2.2" viewBox="0 0 24 24"><path d="M6 9l6 6 6-6" /></svg>
      </button>
      {open && (
        <ul className="absolute z-30 mt-2 w-full bg-white rounded-xl shadow-xl border border-gray-100 max-h-56 overflow-y-auto animate-fadeInUp" tabIndex={-1} role="listbox">
          {dayOptions.map(opt => (
            <li
              key={opt.value}
              className={`px-4 py-2 hover:bg-yellow-50 cursor-pointer flex items-center gap-2 ${opt.value === value ? 'bg-yellow-100 font-semibold text-yellow-700' : ''}`}
              onClick={() => {
                onChange(opt.value);
                setOpen(false);
              }}
              role="option"
              aria-selected={opt.value === value}
            >
              <Calendar size={16} className="text-yellow-400" />
              {opt.label}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

export default DaySelect; 