import React, { useState, useMemo } from 'react';
import { User, MagnifyingGlass, Plus } from 'phosphor-react';
import AddPatient from '../pages/AddPatient';
import { createPortal } from 'react-dom';
import api from '../services/api';

interface Patient {
  id: string;
  name: string;
  lastNamePaterno?: string;
  lastNameMaterno?: string;
}

interface PatientSelectProps {
  value: string;
  onChange: (id: string) => void;
  patients: Patient[];
  disabled?: boolean;
  onPatientAdded?: (newPatient: Patient) => void;
}

const PatientSelect: React.FC<PatientSelectProps> = ({ value, onChange, patients, disabled, onPatientAdded }) => {
  const [open, setOpen] = useState(false);
  const [search, setSearch] = useState('');
  const [showAddPatient, setShowAddPatient] = useState(false);

  // Función para normalizar texto (eliminar acentos y convertir a minúsculas)
  const normalizeText = (text: string) => {
    return text.toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '');
  };

  const filtered = useMemo(
    () => patients.filter(p => {
      const q = normalizeText(search);
      return (
        normalizeText(p.name).includes(q) ||
        normalizeText(p.lastNamePaterno || '').includes(q) ||
        normalizeText(p.lastNameMaterno || '').includes(q)
      );
    }),
    [patients, search]
  );

  const selected = patients.find(p => p.id === value);

  const handlePatientAdded = async () => {
    setShowAddPatient(false);
    try {
      // Obtener la lista actualizada de pacientes
      const response = await api.get('/patients');
      const newPatients = response.data;
      
      // Si hay un callback, llamarlo con el último paciente agregado
      if (onPatientAdded && newPatients.length > 0) {
        const lastPatient = newPatients[newPatients.length - 1];
        onPatientAdded(lastPatient);
      }
    } catch (error) {
      console.error('Error al actualizar la lista de pacientes:', error);
    }
  };

  return (
    <div className="flex gap-2">
      <div className="relative flex-1">
        <button
          type="button"
          className={`w-full flex items-center gap-2 border border-gray-200 rounded-xl pl-3 pr-10 py-2 bg-white text-gray-700 focus:border-red-400 focus:ring-2 focus:ring-red-100 shadow-sm transition-all hover:border-red-300 ${disabled ? 'opacity-60 cursor-not-allowed' : 'cursor-pointer'}`}
          onClick={() => !disabled && setOpen(o => !o)}
          disabled={disabled}
          aria-haspopup="listbox"
          aria-expanded={open}
        >
          <User size={20} className="text-red-400" weight={selected ? 'fill' : 'regular'} />
          <span className={`flex-1 text-left ${selected ? '' : 'text-gray-400'}`}>{selected ? `${selected.name} ${selected.lastNamePaterno || ''} ${selected.lastNameMaterno || ''}` : 'Selecciona un paciente'}</span>
          <svg className="absolute right-3 top-1/2 -translate-y-1/2 text-red-300" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2.2" viewBox="0 0 24 24"><path d="M6 9l6 6 6-6" /></svg>
        </button>
        {open && (
          <div className="absolute z-30 mt-2 w-full bg-white rounded-xl shadow-xl border border-gray-100 max-h-56 overflow-y-auto animate-fadeInUp">
            <div className="flex items-center gap-2 px-3 py-2 border-b border-gray-50 bg-gray-50 sticky top-0">
              <MagnifyingGlass size={16} className="text-gray-400" />
              <input
                type="text"
                className="flex-1 bg-transparent outline-none text-sm text-gray-700"
                placeholder="Buscar paciente..."
                value={search}
                onChange={e => setSearch(e.target.value)}
                autoFocus
              />
            </div>
            <ul tabIndex={-1} role="listbox">
              {filtered.length === 0 && (
                <li className="px-4 py-2 text-gray-400 text-sm">No hay resultados</li>
              )}
              {filtered.map(p => (
                <li
                  key={p.id}
                  className={`px-4 py-2 hover:bg-red-50 cursor-pointer flex items-center gap-2 ${p.id === value ? 'bg-red-100 font-semibold text-red-700' : ''}`}
                  onClick={() => {
                    onChange(p.id);
                    setOpen(false);
                    setSearch('');
                  }}
                  role="option"
                  aria-selected={p.id === value}
                >
                  <User size={18} className="text-red-400" weight={p.id === value ? 'fill' : 'regular'} />
                  {p.name} {p.lastNamePaterno || ''} {p.lastNameMaterno || ''}
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>
      <button
        type="button"
        onClick={() => setShowAddPatient(true)}
        disabled={disabled}
        className="flex items-center justify-center w-10 h-10 bg-red-600 hover:bg-red-700 text-white rounded-xl font-medium transition-colors disabled:opacity-60 disabled:cursor-not-allowed"
        title="Agregar nuevo paciente"
      >
        <Plus size={20} weight="bold" />
      </button>
      {showAddPatient && createPortal(
        <AddPatient onSuccess={handlePatientAdded} />,
        document.body
      )}
    </div>
  );
};

export default React.memo(PatientSelect);
