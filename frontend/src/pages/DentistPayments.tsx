import React, { useState, useEffect } from 'react';
import DashboardLayout from '../components/DashboardLayout';
import { Money, Plus, X, MagnifyingGlass } from 'phosphor-react';
import api from '../services/api';

interface Payment {
  id: string;
  dentistId: string;
  period: string;
  baseSalary: number;
  commission: number;
  deductions: number;
  total: number;
  status: 'pending' | 'paid' | 'cancelled';
  paymentDate: string;
  dentist: { id: string; name: string; lastNamePaterno?: string; lastNameMaterno?: string };
}

const DentistSelect: React.FC<{ value: string; onChange: (id: string) => void; dentists: { id: string; name: string }[]; disabled?: boolean }> = ({ value, onChange, dentists, disabled }) => {
  const [open, setOpen] = React.useState(false);
  const selected = dentists.find(d => d.id === value);
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
        <span className="flex-1 text-left">{selected ? selected.name : 'Selecciona un odontólogo'}</span>
        <svg className="absolute right-3 top-1/2 -translate-y-1/2 text-red-300" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2.2" viewBox="0 0 24 24"><path d="M6 9l6 6 6-6" /></svg>
      </button>
      {open && (
        <ul className="absolute z-30 mt-2 w-full bg-white rounded-xl shadow-xl border border-gray-100 max-h-56 overflow-y-auto animate-fadeInUp" tabIndex={-1} role="listbox">
          {dentists.map(d => (
            <li
              key={d.id}
              className={`px-4 py-2 hover:bg-red-50 cursor-pointer flex items-center gap-2 ${d.id === value ? 'bg-red-100 font-semibold text-red-700' : ''}`}
              onClick={() => {
                onChange(d.id);
                setOpen(false);
              }}
              role="option"
              aria-selected={d.id === value}
            >
              {d.name}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

const DentistPayments: React.FC = () => {
  const [payments, setPayments] = useState<Payment[]>([]);
  const [summary, setSummary] = useState<{ totalPaid?: number; totalPending?: number; totalCommission?: number; avgCommission?: number }>({});
  const [search, setSearch] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [form, setForm] = useState({
    dentistId: '',
    period: '',
    baseSalary: '',
    commission: '',
    deductions: '',
    total: '',
    status: 'pending',
    paymentDate: ''
  });
  const [loading, setLoading] = useState(false);
  const [dentists, setDentists] = useState<{ id: string; name: string }[]>([]);

  useEffect(() => {
    api.get('/payments/dentist')
      .then(res => setPayments(res.data))
      .catch(err => console.error('Error al cargar pagos:', err));
      
    api.get('/payments/dentist/summary')
      .then(res => setSummary(res.data))
      .catch(err => console.error('Error al cargar resumen:', err));
      
    api.get('/users')
      .then(res => {
        const data = res.data;
        setDentists(Array.isArray(data) ? data.filter((u: any) => u.role === 'DENTIST') : []);
      })
      .catch(err => console.error('Error al cargar odontólogos:', err));
  }, []);

  const filteredPayments = Array.isArray(payments)
    ? payments.filter(payment =>
        (payment.dentist?.name?.toLowerCase() || '').includes(search.toLowerCase()) ||
        (payment.period?.toLowerCase() || '').includes(search.toLowerCase())
      )
    : [];

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      await api.post('/payments/dentist', {
        dentistId: form.dentistId,
        period: form.period,
        baseSalary: form.baseSalary,
        commission: form.commission,
        deductions: form.deductions,
        total: form.total,
        status: form.status,
        paymentDate: form.paymentDate
      });
      
      setShowModal(false);
      setForm({ dentistId: '', period: '', baseSalary: '', commission: '', deductions: '', total: '', status: 'pending', paymentDate: '' });
      
      // Recargar pagos y resumen
      const [paymentsRes, summaryRes] = await Promise.all([
        api.get('/payments/dentist'),
        api.get('/payments/dentist/summary')
      ]);
      
      setPayments(paymentsRes.data);
      setSummary(summaryRes.data);
    } catch (err) {
      alert('Error al guardar el pago');
    } finally {
      setLoading(false);
    }
  };

  return (
    <DashboardLayout>
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
        <div className="flex items-center gap-4 flex-1 mb-2 sm:mb-0">
          <div className="bg-red-100 text-red-600 rounded-full p-3">
            <Money size={38} weight="duotone" />
          </div>
          <div>
            <h2 className="text-2xl font-bold text-gray-800 mb-1">Pagos a Odontólogos</h2>
            <p className="text-gray-500 text-base font-medium">Gestión de pagos y comisiones.</p>
          </div>
        </div>
        <div className="flex items-center gap-2 w-full sm:w-auto">
          <div className="relative w-full max-w-xs">
            <input
              type="text"
              placeholder="Buscar por odontólogo o período..."
              className="w-full pl-12 pr-4 py-2 rounded-xl border-2 border-gray-200 focus:border-red-400 focus:ring-2 focus:ring-red-100 text-gray-700 bg-white shadow transition-all placeholder-gray-400"
              value={search}
              onChange={e => setSearch(e.target.value)}
            />
            <span className="absolute left-4 top-1/2 -translate-y-1/2 text-red-400 pointer-events-none">
              <svg width="22" height="22" fill="none" stroke="currentColor" strokeWidth="2.2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="M21 21l-2-2"/></svg>
            </span>
          </div>
          <button
            className="bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-lg transition-all duration-200 shadow-md ml-2 whitespace-nowrap text-base"
            style={{ minHeight: '40px', minWidth: 'auto', fontSize: '1rem', paddingTop: '0.5rem', paddingBottom: '0.5rem', paddingLeft: '1rem', paddingRight: '1rem' }}
            onClick={() => setShowModal(true)}
          >
            + Nuevo Pago
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
        <div className="bg-white rounded-2xl shadow-xl p-6">
          <h3 className="text-lg font-semibold text-gray-800 mb-4">Resumen de Pagos</h3>
          <div className="space-y-4">
            <div className="flex justify-between items-center">
              <span className="text-gray-600">Total Pagado</span>
              <span className="text-2xl font-bold text-gray-800">${(summary.totalPaid ?? 0).toLocaleString()}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-gray-600">Pagos Pendientes</span>
              <span className="text-2xl font-bold text-red-600">${(summary.totalPending ?? 0).toLocaleString()}</span>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-2xl shadow-xl p-6">
          <h3 className="text-lg font-semibold text-gray-800 mb-4">Comisiones</h3>
          <div className="space-y-4">
            <div className="flex justify-between items-center">
              <span className="text-gray-600">Comisión Promedio</span>
              <span className="text-2xl font-bold text-gray-800">{typeof summary.avgCommission === 'number' ? `${summary.avgCommission.toFixed(2)}%` : '0%'}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-gray-600">Comisión Total</span>
              <span className="text-2xl font-bold text-gray-800">${(summary.totalCommission ?? 0).toLocaleString()}</span>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-2xl shadow-xl p-6">
          <h3 className="text-lg font-semibold text-gray-800 mb-4">Configuración</h3>
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <span className="text-gray-700">Período de Pago</span>
              <span className="text-gray-600">Quincenal</span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-gray-700">Día de Pago</span>
              <span className="text-gray-600">15 y 30</span>
            </div>
          </div>
        </div>
      </div>

      <div className="bg-white rounded-2xl shadow-xl overflow-x-auto border border-gray-200">
        <table className="min-w-full divide-y divide-gray-100">
          <thead className="bg-gray-50 sticky top-0 z-10">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Odontólogo</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Período</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Salario Base</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Comisión</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Deducciones</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Total</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Estado</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Acciones</th>
            </tr>
          </thead>
          <tbody>
            {filteredPayments.map(payment => (
              <tr key={payment.id} className="hover:bg-red-50 transition-all border-b border-gray-100 last:border-0 group">
                <td className="px-6 py-4 font-medium text-gray-900">{payment.dentist?.name} {payment.dentist?.lastNamePaterno || ''} {payment.dentist?.lastNameMaterno || ''}</td>
                <td className="px-6 py-4">{payment.period}</td>
                <td className="px-6 py-4">${payment.baseSalary.toLocaleString()}</td>
                <td className="px-6 py-4">${payment.commission.toLocaleString()}</td>
                <td className="px-6 py-4">${payment.deductions.toLocaleString()}</td>
                <td className="px-6 py-4 font-semibold">${payment.total.toLocaleString()}</td>
                <td className="px-6 py-4">
                  <span className={`px-2 py-1 rounded-full text-xs font-semibold ${
                    payment.status === 'paid' ? 'bg-green-100 text-green-600' :
                    payment.status === 'pending' ? 'bg-yellow-100 text-yellow-600' :
                    'bg-red-100 text-red-600'
                  }`}>
                    {payment.status === 'paid' ? 'Pagado' :
                     payment.status === 'pending' ? 'Pendiente' : 'Cancelado'}
                  </span>
                </td>
                <td className="px-6 py-4 text-right">
                  <button
                    onClick={() => {/* Aquí iría la lógica para ver detalles */}}
                    className="inline-flex items-center gap-1 text-red-600 hover:text-white hover:bg-red-600 border border-red-200 font-semibold px-3 py-1.5 rounded-lg transition-all duration-150 focus:outline-none focus:ring-2 focus:ring-red-300 group-hover:bg-red-600 group-hover:text-white"
                  >
                    <svg width="20" height="20" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                    Ver
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {showModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-lg p-0 relative overflow-hidden animate-fadeInUp">
            <div className="flex items-center gap-3 bg-gradient-to-r from-red-100 to-red-50 px-8 py-6 border-b border-red-100">
              <div className="bg-red-200 text-red-600 rounded-full p-3">
                <Money size={30} className="text-red-500" />
              </div>
              <div className="flex-1">
                <h3 className="text-xl font-bold text-gray-800">Nuevo Pago a Odontólogo</h3>
                <div className="text-gray-400 text-sm">Completa los datos para registrar el pago</div>
              </div>
              <button
                className="ml-auto text-gray-400 hover:text-red-600 text-2xl font-bold p-1 rounded-full transition-colors focus:outline-none"
                onClick={() => setShowModal(false)}
                aria-label="Cerrar"
                type="button"
              >
                <svg width="28" height="28" fill="none" stroke="#e11d48" strokeWidth="2.2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M15 9l-6 6M9 9l6 6"/></svg>
              </button>
            </div>
            <form
              onSubmit={handleSubmit}
              className="px-8 py-7 space-y-4"
            >
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Odontólogo</label>
                <DentistSelect
                  value={form.dentistId}
                  onChange={id => setForm({ ...form, dentistId: id })}
                  dentists={dentists}
                  disabled={loading}
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Período</label>
                <input
                  type="text"
                  className="w-full border border-gray-200 rounded-xl px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
                  value={form.period}
                  onChange={e => setForm({ ...form, period: e.target.value })}
                  required
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Salario Base</label>
                  <input
                    type="number"
                    className="w-full border border-gray-200 rounded-xl px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
                    value={form.baseSalary}
                    onChange={e => setForm({ ...form, baseSalary: e.target.value })}
                    required
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Comisión</label>
                  <input
                    type="number"
                    className="w-full border border-gray-200 rounded-xl px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
                    value={form.commission}
                    onChange={e => setForm({ ...form, commission: e.target.value })}
                    required
                  />
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Deducciones</label>
                  <input
                    type="number"
                    className="w-full border border-gray-200 rounded-xl px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
                    value={form.deductions}
                    onChange={e => setForm({ ...form, deductions: e.target.value })}
                    required
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Total</label>
                  <input
                    type="number"
                    className="w-full border border-gray-200 rounded-xl px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
                    value={form.total}
                    onChange={e => setForm({ ...form, total: e.target.value })}
                    required
                  />
                </div>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Fecha de Pago</label>
                <input
                  type="date"
                  className="w-full border border-gray-200 rounded-xl px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
                  value={form.paymentDate}
                  onChange={e => setForm({ ...form, paymentDate: e.target.value })}
                  required
                />
              </div>
              <button
                type="submit"
                className="w-full bg-gradient-to-r from-red-600 to-red-500 hover:from-red-700 hover:to-red-600 text-white font-bold py-2 px-4 rounded-xl transition-all duration-200 shadow-md text-base flex items-center justify-center gap-2"
                disabled={loading}
              >
                Guardar Pago
              </button>
            </form>
          </div>
        </div>
      )}
    </DashboardLayout>
  );
};

export default DentistPayments; 