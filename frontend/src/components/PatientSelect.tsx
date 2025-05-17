import React, { useState, useMemo, useRef, useEffect } from 'react';
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

const DEFAULT_LIMIT = 15;

const PatientSelect: React.FC<PatientSelectProps> = ({ value, onChange, disabled, onPatientAdded }) => {
  const [search, setSearch] = useState('');
  const [showAddPatient, setShowAddPatient] = useState(false);
  const [options, setOptions] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [selectedLabel, setSelectedLabel] = useState<string>('');
  const debounceRef = useRef<NodeJS.Timeout | null>(null);
  const loadedInitial = useRef(false);

  // Cargar el label del paciente seleccionado si no está en options
  useEffect(() => {
    if (value && !options.find(opt => opt.value === value)) {
      api.get(`/patients/${value}`)
        .then(res => {
          const p = res.data;
          setSelectedLabel(`${p.name} ${p.lastNamePaterno || ''} ${p.lastNameMaterno || ''}`.trim());
        })
        .catch(() => setSelectedLabel(''));
    }
  }, [value]);

  // Cargar pacientes recientes al abrir el selector
  const handleDropdownVisibleChange = (open: boolean) => {
    if (open && !loadedInitial.current) {
      setLoading(true);
      api.get(`/patients?take=${DEFAULT_LIMIT}`)
        .then(res => {
          setOptions((res.data || []).map((p: any) => ({
            label: `${p.name} ${p.lastNamePaterno || ''} ${p.lastNameMaterno || ''}`.trim(),
            value: p.id,
          })));
          loadedInitial.current = true;
        })
        .catch(() => setOptions([]))
        .finally(() => setLoading(false));
    }
    if (!open) {
      setOptions([]);
      setSearch('');
      loadedInitial.current = false;
    }
  };

  // Búsqueda remota con debounce y normalización
  const handleSearch = (val: string) => {
    setSearch(val);
    if (debounceRef.current) clearTimeout(debounceRef.current);
    if (!val || val.trim().length === 0) {
      // Si no hay búsqueda, recarga los recientes
      handleDropdownVisibleChange(true);
      return;
    }
    setLoading(true);
    debounceRef.current = setTimeout(async () => {
      try {
        const res = await api.get(`/patients?search=${encodeURIComponent(val)}`);
        setOptions(
          (res.data || []).map((p: any) => ({
            label: `${p.name} ${p.lastNamePaterno || ''} ${p.lastNameMaterno || ''}`.trim(),
            value: p.id,
          }))
        );
      } catch {
        setOptions([]);
      } finally {
        setLoading(false);
      }
    }, 500);
  };

  const handleChange = (id: string) => {
    onChange(id);
  };

  const handlePatientAdded = async (newPatient?: any) => {
    setShowAddPatient(false);
    if (newPatient && newPatient.id) {
      onChange(newPatient.id);
    }
    // Opcional: podrías recargar la búsqueda actual si quieres
  };

  // Opciones combinadas: si el paciente seleccionado no está en options, lo agrego
  const mergedOptions = value && selectedLabel && !options.find(opt => opt.value === value)
    ? [{ value, label: selectedLabel }, ...options]
    : options;

  return (
    <>
      <Select
        showSearch
        value={value || undefined}
        placeholder="Selecciona un paciente"
        optionFilterProp="label"
        onChange={handleChange}
        onSearch={handleSearch}
        filterOption={false}
        disabled={disabled}
        style={{ width: '100%', borderRadius: 12 }}
        dropdownStyle={{ borderRadius: 12, boxShadow: '0 4px 24px 0 rgba(0,0,0,0.10)' }}
        popupClassName="z-50"
        options={mergedOptions}
        notFoundContent={loading ? 'Buscando...' : 'No hay resultados'}
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
        onDropdownVisibleChange={handleDropdownVisibleChange}
      />
      {showAddPatient && createPortal(
        <AddPatient onSuccess={handlePatientAdded} />, document.body
      )}
    </>
  );
};

export default PatientSelect;
