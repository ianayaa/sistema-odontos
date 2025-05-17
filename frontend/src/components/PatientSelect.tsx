import React, { useState, useMemo } from 'react';
import { User, MagnifyingGlass, Plus } from 'phosphor-react';
import AddPatient from '../pages/AddPatient';
import { createPortal } from 'react-dom';
import api from '../services/api';
import { Select } from 'antd';
import 'antd/dist/reset.css';

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

  const options = filtered.map(p => ({
    label: `${p.name} ${p.lastNamePaterno || ''} ${p.lastNameMaterno || ''}`.trim(),
    value: p.id,
  }));

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
    <>
      <Select
        showSearch
        value={value || undefined}
        placeholder="Selecciona un paciente"
        optionFilterProp="label"
        onChange={onChange}
        onSearch={setSearch}
        filterOption={false}
        disabled={disabled}
        style={{ width: '100%', borderRadius: 12 }}
        dropdownStyle={{ borderRadius: 12, boxShadow: '0 4px 24px 0 rgba(0,0,0,0.10)' }}
        popupClassName="z-50"
        options={options}
        dropdownRender={menu => (
          <>
            {menu}
            <div className="flex justify-center p-2 border-t border-gray-100 bg-white">
              <button
                type="button"
                onClick={() => setShowAddPatient(true)}
                className="flex items-center gap-2 px-3 py-2 bg-red-600 hover:bg-red-700 text-white rounded-xl font-medium transition-colors text-sm"
                style={{ width: '100%' }}
              >
                <Plus size={16} weight="bold" /> Agregar nuevo paciente
              </button>
            </div>
          </>
        )}
      />
      {showAddPatient && createPortal(
        <AddPatient onSuccess={handlePatientAdded} />, document.body
      )}
    </>
  );
};

export default PatientSelect;
