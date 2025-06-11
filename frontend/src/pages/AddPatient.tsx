import React, { useState } from 'react';
import api from '../services/api';
import PhoneInput from 'react-phone-input-2';
import 'react-phone-input-2/lib/style.css';
import ModernDatePicker from '../components/ModernDatePicker';
import { UserCircle, X, Phone } from 'phosphor-react';

interface AddPatientProps {
  onSuccess?: () => void;
}

function validateEmail(email: string) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function validatePhone(phone: string) {
  return /^\d{7,15}$/.test(phone.replace(/\D/g, ''));
}

const AddPatient: React.FC<AddPatientProps> = ({ onSuccess }) => {
  const [form, setForm] = useState({
    name: '',
    lastNamePaterno: '',
    lastNameMaterno: '',
    email: '',
    phone: '', // Incluye lada y número
    birthDate: null as Date | null,
    address: ''
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [emailTouched, setEmailTouched] = useState(false);
  const [phoneTouched, setPhoneTouched] = useState(false);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handlePhoneChange = (value: string) => {
    setForm({ ...form, phone: value });
  };

  const handleDateChange = (date: Date | null) => {
    setForm({ ...form, birthDate: date });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    if (form.email && !validateEmail(form.email)) {
      setError('El correo no es válido.');
      setLoading(false);
      return;
    }
    if (!validatePhone(form.phone.replace(/\D/g, ''))) {
      setError('El número de celular no es válido.');
      setLoading(false);
      return;
    }
    try {
      await api.post('/patients', {
        name: form.name,
        lastNamePaterno: form.lastNamePaterno,
        lastNameMaterno: form.lastNameMaterno,
        email: form.email,
        phone: `+${form.phone}`,
        birthDate: form.birthDate ? form.birthDate.toISOString().split('T')[0] : undefined,
        address: form.address
      });
      setForm({ name: '', lastNamePaterno: '', lastNameMaterno: '', email: '', phone: '', birthDate: null, address: '' });
      if (onSuccess) onSuccess();
    } catch (err: any) {
      setError(err.response?.data?.error || 'Error al crear paciente');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 z-[1000] flex items-center justify-center bg-black/60 backdrop-blur-sm">
      <div className="bg-white rounded-3xl shadow-2xl w-full max-w-2xl p-0 relative overflow-hidden animate-fadeInUp border border-gray-200">
        {/* Encabezado con icono y fondo degradado */}
        <div className="flex items-center gap-3 bg-gradient-to-r from-red-100 to-red-50 px-8 py-6 border-b border-red-100 relative">
          <div className="bg-red-200 text-red-600 rounded-full p-3">
            <UserCircle size={32} weight="duotone" />
          </div>
          <div className="flex-1">
            <h3 className="text-xl font-bold text-gray-800">Agregar Nuevo Paciente</h3>
            <div className="text-gray-400 text-sm">Completa los datos para registrar el paciente</div>
          </div>
          <button
            className="ml-auto text-gray-400 hover:text-red-600 text-2xl font-bold p-1 rounded-full transition-colors focus:outline-none"
            onClick={onSuccess}
            aria-label="Cerrar"
            type="button"
          >
            <svg width="28" height="28" fill="none" stroke="#e11d48" strokeWidth="2.2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M15 9l-6 6M9 9l6 6"/></svg>
          </button>
        </div>
        {error && <div className="mx-8 mt-4 bg-red-50 text-red-700 p-2 mb-2 rounded-md border border-red-200">{error}</div>}
        <form onSubmit={handleSubmit} className="space-y-6 px-8 pb-8 pt-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
              <label className="block text-xs font-semibold mb-1 text-gray-600">Nombre</label>
              <input type="text" name="name" value={form.name} onChange={handleChange} required className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-red-500 bg-gray-50" />
            </div>
            <div>
              <label className="block text-xs font-semibold mb-1 text-gray-600">Apellido paterno</label>
              <input type="text" name="lastNamePaterno" value={form.lastNamePaterno} onChange={handleChange} required className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-red-500 bg-gray-50" />
            </div>
            <div>
              <label className="block text-xs font-semibold mb-1 text-gray-600">Apellido materno</label>
              <input type="text" name="lastNameMaterno" value={form.lastNameMaterno} onChange={handleChange} className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-red-500 bg-gray-50" />
            </div>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-semibold mb-1 text-gray-600">Correo electrónico</label>
              <input
                type="email"
                name="email"
                value={form.email}
                onChange={handleChange}
                onBlur={() => setEmailTouched(true)}

                className={`w-full border ${emailTouched && !validateEmail(form.email) ? 'border-red-400' : 'border-gray-300'} rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-red-500 bg-gray-50`}
                placeholder="correo@ejemplo.com"
              />
              {emailTouched && !validateEmail(form.email) && (
                <span className="text-xs text-red-500">Correo no válido</span>
              )}
            </div>
            <div>
              <label className="block text-xs font-semibold mb-1 text-gray-600">Celular</label>
              <div className="relative">
                <span className="absolute left-3 top-1/2 -translate-y-1/2 text-red-300 pointer-events-none">
                  <Phone size={20} weight="duotone" />
                </span>
                <PhoneInput
                  country={'mx'}
                  value={form.phone}
                  onChange={handlePhoneChange}
                  inputClass="!w-full !pl-12 !border !border-gray-300 !rounded-lg !px-3 !py-2 !bg-gray-50 !focus:outline-none !focus:ring-2 !focus:ring-red-500 !text-base"
                  buttonClass="!border-0 !bg-transparent !absolute !left-2 !top-1/2 !-translate-y-1/2 !z-10"
                  containerClass="!w-full"
                  inputStyle={{ width: '100%', paddingLeft: 48, fontSize: '1rem', background: 'inherit' }}
                  buttonStyle={{ border: 'none', background: 'transparent', left: 8, top: '50%', transform: 'translateY(-50%)', position: 'absolute' }}
                  enableSearch
                  disableDropdown={false}
                  masks={{ mx: '.... ......' }}
                  onBlur={() => setPhoneTouched(true)}
                  placeholder="Ej: 55 1234 5678"
                />
              </div>
              {phoneTouched && !validatePhone(form.phone.replace(/\D/g, '')) && (
                <span className="text-xs text-red-500 mt-1 flex items-center gap-1"><Phone size={14}/> Número no válido</span>
              )}
            </div>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-semibold mb-1 text-gray-600">Fecha de nacimiento</label>
              <ModernDatePicker value={form.birthDate} onChange={handleDateChange} />
            </div>
            <div>
              <label className="block text-xs font-semibold mb-1 text-gray-600">Dirección</label>
              <input type="text" name="address" value={form.address} onChange={handleChange} className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-red-500 bg-gray-50" />
            </div>
          </div>
          <div className="flex justify-end gap-2 pt-4">
            <button
              type="button"
              onClick={onSuccess}
              className="px-4 py-2 text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-lg font-semibold transition-colors"
              disabled={loading}
            >
              Cancelar
            </button>
            <button
              type="submit"
              className="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg font-semibold transition-colors flex items-center gap-2"
              disabled={loading}
            >
              {loading ? (
                <>
                  <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                  Guardando...
                </>
              ) : (
                <>
                  <UserCircle size={20} weight="bold" />
                  Guardar Paciente
                </>
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default AddPatient;
