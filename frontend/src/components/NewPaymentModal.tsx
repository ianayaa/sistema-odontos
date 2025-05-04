import React, { useState, useEffect } from 'react';
import { X, CurrencyDollar, User, Calendar, CreditCard, Bank, Money } from 'phosphor-react';
import { getPatients, getPatientAppointments } from '../services/api';
import PatientSelect from './PatientSelect';

interface Props {
  open: boolean;
  onClose: () => void;
  onCreate: (data: any) => void;
}

const paymentMethods = [
  { value: 'credit_card', label: 'Tarjeta de Crédito', icon: <CreditCard size={18} className="text-blue-500" /> },
  { value: 'transfer', label: 'Transferencia', icon: <Bank size={18} className="text-green-500" /> },
  { value: 'cash', label: 'Efectivo', icon: <Money size={18} className="text-yellow-600" /> },
];

const NewPaymentModal: React.FC<Props> = ({ open, onClose, onCreate }) => {
  const [patients, setPatients] = useState<any[]>([]);
  const [patientId, setPatientId] = useState('');
  const [appointments, setAppointments] = useState<any[]>([]);
  const [activeAppointment, setActiveAppointment] = useState<any | null>(null);
  const [amount, setAmount] = useState('');
  const [method, setMethod] = useState('cash');
  const [description, setDescription] = useState('');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (open) {
      getPatients().then(setPatients);
      setPatientId('');
      setAppointments([]);
      setActiveAppointment(null);
      setAmount('');
      setMethod('cash');
      setDescription('');
    }
  }, [open]);

  useEffect(() => {
    if (patientId) {
      getPatientAppointments(patientId).then((appts) => {
        setAppointments(appts);
        // Buscar la cita activa: la más próxima con estado pendiente o confirmada
        const now = new Date();
        const active = appts
          .filter((a: any) => a.status === 'pendiente' || a.status === 'confirmada')
          .sort((a: any, b: any) => new Date(a.date).getTime() - new Date(b.date).getTime())
          .find((a: any) => new Date(a.date) >= now) || null;
        setActiveAppointment(active);
      });
    } else {
      setAppointments([]);
      setActiveAppointment(null);
    }
  }, [patientId]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!patientId || !amount || !method) return;
    setLoading(true);
    try {
      const res = await fetch('/api/payments', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          patientId,
          amount: parseFloat(amount),
          method,
          description,
          appointmentId: activeAppointment?.id || null,
        })
      });
      if (!res.ok) throw new Error('Error al registrar el pago');
      onCreate && onCreate({ patientId, amount: parseFloat(amount), method, description, appointmentId: activeAppointment?.id || null });
      onClose();
    } catch (err) {
      alert('Error al registrar el pago');
    } finally {
      setLoading(false);
    }
  };

  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
      <div className="bg-white rounded-3xl shadow-2xl w-full max-w-lg p-0 relative overflow-hidden animate-fadeInUp">
        <div className="flex items-center gap-3 bg-gradient-to-r from-red-100 to-red-50 px-8 py-6 border-b border-red-100">
          <div className="bg-red-200 text-red-600 rounded-full p-3">
            <CurrencyDollar size={30} className="text-red-500" />
          </div>
          <div className="flex-1">
            <h3 className="text-xl font-bold text-gray-800">Nuevo Pago</h3>
            <div className="text-gray-400 text-sm">Completa los datos para registrar el pago</div>
          </div>
          <button
            className="ml-auto text-gray-400 hover:text-red-600 text-2xl font-bold p-1 rounded-full transition-colors focus:outline-none"
            onClick={onClose}
            aria-label="Cerrar"
            type="button"
          >
            <svg width="28" height="28" fill="none" stroke="#e11d48" strokeWidth="2.2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M15 9l-6 6M9 9l6 6"/></svg>
          </button>
        </div>
        <form onSubmit={handleSubmit} className="px-8 py-7 space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Paciente</label>
            <PatientSelect
              value={patientId}
              onChange={setPatientId}
              patients={patients}
              disabled={loading}
            />
          </div>
          {activeAppointment && (
            <div className="bg-gray-50 border border-gray-100 rounded-lg p-3 flex items-center gap-3">
              <Calendar size={22} className="text-red-400" />
              <div>
                <div className="text-xs text-gray-500">Cita activa</div>
                <div className="font-semibold text-gray-800 text-sm">
                  {new Date(activeAppointment.date).toLocaleDateString('es-MX', { year: 'numeric', month: 'short', day: 'numeric' })}
                  {', '}
                  {new Date(activeAppointment.date).toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' })}
                </div>
                <div className="text-xs text-gray-500">{activeAppointment.treatment || 'Sin tratamiento especificado'}</div>
              </div>
            </div>
          )}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Monto</label>
            <input
              type="number"
              min="0"
              step="0.01"
              className="w-full border border-gray-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
              value={amount}
              onChange={e => setAmount(e.target.value)}
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Método de pago</label>
            <div className="flex gap-2">
              {paymentMethods.map(m => (
                <button
                  key={m.value}
                  type="button"
                  className={`flex items-center gap-1 px-3 py-2 rounded-lg border transition-colors text-sm font-semibold ${method === m.value ? 'bg-red-100 border-red-400 text-red-700' : 'bg-white border-gray-200 text-gray-600 hover:border-red-300'}`}
                  onClick={() => setMethod(m.value)}
                >
                  {m.icon} {m.label}
                </button>
              ))}
            </div>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Descripción (opcional)</label>
            <textarea
              className="w-full border border-gray-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
              value={description}
              onChange={e => setDescription(e.target.value)}
              rows={2}
            />
          </div>
          <button
            type="submit"
            className="w-full bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-lg transition-colors flex items-center justify-center gap-2"
            disabled={loading || !patientId || !amount}
          >
            <CurrencyDollar size={20} /> Registrar Pago
          </button>
        </form>
      </div>
    </div>
  );
};

export default NewPaymentModal; 