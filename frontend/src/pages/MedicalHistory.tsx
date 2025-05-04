import React, { useState } from 'react';
import DashboardLayout from '../components/DashboardLayout';

const initialState = {
  allergies: '',
  medications: '',
  conditions: '',
  notes: '',
};

const MedicalHistory: React.FC = () => {
  const [form, setForm] = useState(initialState);
  const [saving, setSaving] = useState(false);
  const [success, setSuccess] = useState(false);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    setTimeout(() => {
      setSaving(false);
      setSuccess(true);
      setTimeout(() => setSuccess(false), 2000);
    }, 1200); // Simulación de guardado
  };

  return (
    <DashboardLayout>
      <h2 className="text-2xl font-bold mb-4">Historia Clínica</h2>
      <form onSubmit={handleSubmit} className="bg-white rounded-xl shadow p-8 max-w-xl mx-auto space-y-6 border border-gray-100">
        <div>
          <label className="block text-sm font-semibold text-gray-700 mb-1">Alergias</label>
          <input
            type="text"
            name="allergies"
            className="w-full border border-gray-200 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-red-200 bg-gray-50"
            placeholder="Ej: Penicilina, anestesia, etc."
            value={form.allergies}
            onChange={handleChange}
          />
        </div>
        <div>
          <label className="block text-sm font-semibold text-gray-700 mb-1">Medicamentos actuales</label>
          <input
            type="text"
            name="medications"
            className="w-full border border-gray-200 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-red-200 bg-gray-50"
            placeholder="Ej: Ibuprofeno, insulina, etc."
            value={form.medications}
            onChange={handleChange}
          />
        </div>
        <div>
          <label className="block text-sm font-semibold text-gray-700 mb-1">Enfermedades sistémicas</label>
          <input
            type="text"
            name="conditions"
            className="w-full border border-gray-200 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-red-200 bg-gray-50"
            placeholder="Ej: Diabetes, hipertensión, etc."
            value={form.conditions}
            onChange={handleChange}
          />
        </div>
        <div>
          <label className="block text-sm font-semibold text-gray-700 mb-1">Notas adicionales</label>
          <textarea
            name="notes"
            className="w-full border border-gray-200 rounded-lg px-4 py-2 min-h-[80px] focus:outline-none focus:ring-2 focus:ring-red-200 bg-gray-50"
            placeholder="Observaciones relevantes, antecedentes familiares, etc."
            value={form.notes}
            onChange={handleChange}
          />
        </div>
        <div className="flex justify-end gap-4">
          <button
            type="submit"
            className="bg-red-600 hover:bg-red-700 text-white font-bold px-6 py-2 rounded-lg transition-all duration-200 shadow disabled:opacity-60"
            disabled={saving}
          >
            {saving ? 'Guardando...' : 'Guardar'}
          </button>
          {success && <span className="text-green-600 font-semibold self-center">¡Guardado!</span>}
        </div>
      </form>
    </DashboardLayout>
  );
};

export default MedicalHistory;
