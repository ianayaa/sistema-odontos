import React, { useEffect, useState } from 'react';
import DashboardLayout from '../components/DashboardLayout';
import { CurrencyDollar, Trash, X, PencilSimple } from 'phosphor-react';
import api, { getPaymentSummary } from '../services/api';
import NewPaymentModal from '../components/NewPaymentModal';
import ModernDatePicker from '../components/ModernDatePicker';
import PatientSelect from '../components/PatientSelect';
import StatusSelect from '../components/StatusSelect';

interface Payment {
  id: string;
  amount: number;
  method: string;
  status: 'pending' | 'completed' | 'failed' | 'refunded';
  patient: {
    id: string;
    name: string;
    lastNamePaterno?: string;
    lastNameMaterno?: string;
  };
  date: string;
  reference: string;
  description?: string;
}

const PaymentMethodSelect = ({ value, onChange }: { value: string; onChange: (v: string) => void }) => {
  const [open, setOpen] = React.useState(false);
  const options = [
    { value: '', label: 'Todos', icon: <span className="text-gray-400">•</span> },
    { value: 'credit_card', label: 'Tarjeta de Crédito', icon: <svg className="text-blue-500" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2.2" viewBox="0 0 24 24"><rect x="2" y="5" width="20" height="14" rx="2"/><path d="M2 10h20"/></svg> },
    { value: 'transfer', label: 'Transferencia', icon: <svg className="text-green-500" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2.2" viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="M16 3v4M8 3v4M3 9h18"/></svg> },
    { value: 'cash', label: 'Efectivo', icon: <svg className="text-yellow-600" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2.2" viewBox="0 0 24 24"><rect x="2" y="7" width="20" height="10" rx="2"/><path d="M6 11h.01M18 11h.01"/></svg> },
  ];
  const selected = options.find(o => o.value === value) || options[0];
  return (
    <div className="relative">
      <button
        type="button"
        className="w-full flex items-center gap-2 border border-gray-200 rounded-xl px-3 pr-10 py-2 bg-white text-gray-700 focus:border-red-400 focus:ring-2 focus:ring-red-100 shadow-sm transition-all hover:border-red-300 cursor-pointer"
        onClick={() => setOpen(o => !o)}
        aria-haspopup="listbox"
        aria-expanded={open}
      >
        {selected.icon}
        <span className={`flex-1 text-left ${selected.value ? '' : 'text-gray-400'}`}>{selected.label}</span>
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

const Payments: React.FC = () => {
  const [payments, setPayments] = useState<Payment[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [summary, setSummary] = useState<any>(null);
  const [monthStats, setMonthStats] = useState<{ count: number; avg: number }>({ count: 0, avg: 0 });
  const [startDate, setStartDate] = useState<Date | null>(null);
  const [endDate, setEndDate] = useState<Date | null>(null);
  const [showFilterModal, setShowFilterModal] = useState(false);
  const [tempStartDate, setTempStartDate] = useState<Date | null>(null);
  const [tempEndDate, setTempEndDate] = useState<Date | null>(null);
  const [tempPatientId, setTempPatientId] = useState('');
  const [tempMethod, setTempMethod] = useState('');
  const [tempStatus, setTempStatus] = useState('');
  const [patients, setPatients] = useState<any[]>([]);
  const [patientId, setPatientId] = useState('');
  const [method, setMethod] = useState('');
  const [status, setStatus] = useState('');
  const [selectedPayment, setSelectedPayment] = useState<Payment | null>(null);
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);
  const [deleting, setDeleting] = useState(false);
  const [deleteError, setDeleteError] = useState<string | null>(null);
  const [showEstadoEdit, setShowEstadoEdit] = useState(false);
  const lapizRef = React.useRef<HTMLButtonElement | null>(null);
  const [anchorEl, setAnchorEl] = useState<HTMLElement | null>(null);
  const [confirmModal, setConfirmModal] = useState<{ open: boolean, estado: string, label: string, onConfirm: () => void } | null>(null);

  const fetchPayments = () => {
    setLoading(true);
    api.get('/payments', {
      params: {
        startDate: startDate ? startDate.toISOString() : undefined,
        endDate: endDate ? endDate.toISOString() : undefined,
        patientId: patientId || undefined,
        method: method || undefined,
        status: status || undefined,
      }
    })
      .then(res => {
        // Normalizar el status a los valores válidos del tipo Payment
        const statusMap: Record<string, Payment['status']> = {
          pending: 'pending',
          completed: 'completed',
          refunded: 'refunded',
          cancelled: 'refunded', // si quieres mapear 'cancelled' a 'refunded', o puedes agregar 'cancelled' como estado válido si lo deseas
          failed: 'failed',
        };
        const pagos = (res.data as Payment[]).map((p: any) => ({
          ...p,
          status: statusMap[(p.status || '').toLowerCase()] || 'pending',
        }));
        setPayments(pagos);
        // Si el modal está abierto, actualiza selectedPayment si corresponde
        if (selectedPayment) {
          const actualizado = pagos.find(p => p.id === selectedPayment.id);
          if (actualizado) setSelectedPayment(actualizado);
        }
      })
      .finally(() => setLoading(false));
  };

  const fetchSummary = async () => {
    const data = await getPaymentSummary({
      startDate: startDate ? startDate.toISOString() : undefined,
      endDate: endDate ? endDate.toISOString() : undefined,
      patientId: patientId || undefined,
      method: method || undefined,
      status: status || undefined,
    });
    setSummary(data);
  };

  const fetchMonthStats = async () => {
    let sDate = startDate;
    let eDate = endDate;
    if (!sDate || !eDate) {
      const now = new Date();
      sDate = new Date(now.getFullYear(), now.getMonth(), 1);
      eDate = new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59);
    }
    const data = await getPaymentSummary({ startDate: sDate.toISOString(), endDate: eDate.toISOString() });
    const pagosMes = data && data.byStatus?.completed ? data.byStatus.completed : 0;
    const totalMes = data && data.total ? data.total : 0;
    setMonthStats({ count: pagosMes, avg: pagosMes ? totalMes / pagosMes : 0 });
  };

  useEffect(() => {
    fetchMonthStats();
    fetchPayments();
    fetchSummary();
    setTempStartDate(startDate);
    setTempEndDate(endDate);
    setTempPatientId(patientId);
    setTempMethod(method);
    setTempStatus(status);
    if (showFilterModal && patients.length === 0) {
      api.get('/patients').then(res => setPatients(res.data));
    }
  }, [startDate, endDate, patientId, method, status, showFilterModal, patients.length]);

  const handleCreatePayment = () => {
    setShowModal(false);
    fetchPayments();
    fetchSummary();
    fetchMonthStats();
  };

  const handleDeletePayment = async () => {
    if (!selectedPayment) return;
    setDeleting(true);
    setDeleteError(null);
    try {
      await api.delete(`/payments/${selectedPayment.id}`);
      setSelectedPayment(null);
      setShowDeleteConfirm(false);
      fetchPayments();
      fetchSummary();
      fetchMonthStats();
    } catch (err: any) {
      let msg = 'Error al eliminar el pago';
      if (err.response && err.response.data && err.response.data.error) {
        msg += `: ${err.response.data.error}`;
      } else if (err.message) {
        msg += `: ${err.message}`;
      }
      setDeleteError(msg);
    } finally {
      setDeleting(false);
    }
  };

  const filteredPayments = payments.filter(payment => 
    payment.patient?.name.toLowerCase().includes(search.toLowerCase()) ||
    payment.reference.toLowerCase().includes(search.toLowerCase())
  );

  const paymentMethodLabel = (method: string) => {
    switch (method) {
      case 'CASH':
        return 'Efectivo';
      case 'CARD':
        return 'Tarjeta';
      case 'TRANSFER':
        return 'Transferencia';
      default:
        return method;
    }
  };

  // Componente para cambiar el estado del pago
  const estadosPago = [
    { value: 'PENDING', label: 'Pendiente' },
    { value: 'COMPLETED', label: 'Completado' },
    { value: 'CANCELLED', label: 'Cancelado' },
    { value: 'REFUNDED', label: 'Reembolsado' },
  ];

  const EstadoPagoDropdown: React.FC<{ payment: Payment; onStatusChange: () => void; onClose?: () => void; confirmChange?: boolean; anchorEl?: HTMLElement | null }> = ({ payment, onStatusChange, onClose, confirmChange, anchorEl }) => {
    const [open, setOpen] = React.useState(true);
    const [loading, setLoading] = React.useState(false);
    const menuRef = React.useRef<HTMLUListElement>(null);

    React.useEffect(() => {
      if (anchorEl && menuRef.current) {
        const rect = anchorEl.getBoundingClientRect();
        const menu = menuRef.current;
        // Posiciona el menú a la derecha del lápiz, pero si se sale de la pantalla, lo ajusta
        let left = rect.right + 8;
        let top = rect.top;
        if (left + 180 > window.innerWidth) left = window.innerWidth - 200;
        if (top + 180 > window.innerHeight) top = window.innerHeight - 200;
        menu.style.position = 'fixed';
        menu.style.left = `${left}px`;
        menu.style.top = `${top}px`;
        menu.style.zIndex = '9999';
      }
    }, [anchorEl]);

    const handleChange = (nuevoEstado: string, label: string) => {
      if (confirmChange) {
        setConfirmModal({
          open: true,
          estado: nuevoEstado,
          label,
          onConfirm: async () => {
            setLoading(true);
            try {
              await api.put(`/payments/${payment.id}/status`, { status: nuevoEstado });
              setOpen(false);
              if (onClose) onClose();
              onStatusChange();
            } catch (e) {
              alert('Error al cambiar el estado');
            } finally {
              setLoading(false);
              setConfirmModal(null);
            }
          }
        });
        return;
      }
      // Si no requiere confirmación
      setLoading(true);
      api.put(`/payments/${payment.id}/status`, { status: nuevoEstado })
        .then(() => {
          setOpen(false);
          if (onClose) onClose();
          onStatusChange();
        })
        .catch(() => alert('Error al cambiar el estado'))
        .finally(() => setLoading(false));
    };

    if (!open) return null;
    return (
      <>
        <ul
          ref={menuRef}
          className="shadow-lg rounded-2xl border border-gray-200 bg-white min-w-[180px] py-2 animate-fadeInUp"
          style={{ boxShadow: '0 8px 32px #0002', padding: 0 }}
          tabIndex={-1}
          role="listbox"
        >
          {estadosPago.map((opt, idx) => (
            <li
              key={opt.value}
              className={`px-5 py-2 cursor-pointer flex items-center gap-2 transition-all ${opt.value.toLowerCase() === payment.status ? 'bg-red-50 text-red-700 font-bold' : 'hover:bg-gray-50 text-gray-800'} ${idx !== estadosPago.length - 1 ? 'border-b border-gray-100' : ''}`}
              onClick={() => handleChange(opt.value, opt.label)}
              role="option"
              aria-selected={opt.value.toLowerCase() === payment.status}
              style={{ fontSize: '1rem', minHeight: '38px', lineHeight: '1.2' }}
            >
              {opt.label}
            </li>
          ))}
        </ul>
        {/* Modal de confirmación visual */}
        {confirmModal?.open && (
          <div className="fixed inset-0 z-[9999] flex items-center justify-center bg-black/40 backdrop-blur-sm">
            <div className="bg-white rounded-2xl shadow-2xl p-8 w-full max-w-xs relative animate-fadeInUp flex flex-col items-center">
              <div className="text-lg font-bold text-gray-800 mb-2 text-center">¿Seguro que deseas cambiar el estado a "{confirmModal.label}"?</div>
              <div className="flex gap-3 mt-4">
                <button
                  className="bg-gray-100 hover:bg-gray-200 text-gray-700 font-semibold py-2 px-4 rounded-lg"
                  onClick={() => setConfirmModal(null)}
                  disabled={loading}
                >
                  Cancelar
                </button>
                <button
                  className="bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-lg"
                  onClick={confirmModal.onConfirm}
                  disabled={loading}
                >
                  Confirmar
                </button>
              </div>
            </div>
          </div>
        )}
      </>
    );
  };

  // Función para mostrar el label en español y la clase de color
  const paymentStatusLabel = (status: Payment['status']) => {
    switch (status) {
      case 'completed': return 'Completado';
      case 'pending': return 'Pendiente';
      case 'failed': return 'Fallido';
      case 'refunded': return 'Reembolsado';
      default: return status;
    }
  };
  const paymentStatusClass = (status: Payment['status']) => {
    switch (status) {
      case 'completed': return 'bg-green-100 text-green-600';
      case 'pending': return 'bg-yellow-100 text-yellow-600';
      case 'failed': return 'bg-red-100 text-red-600';
      case 'refunded': return 'bg-gray-100 text-gray-600';
      default: return 'bg-gray-100 text-gray-600';
    }
  };

  return (
    <DashboardLayout>
      <NewPaymentModal open={showModal} onClose={() => setShowModal(false)} onCreate={handleCreatePayment} />
      {showFilterModal && (
        <div className="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50">
          <div className="bg-white rounded-2xl shadow-2xl p-6 w-full max-w-xs relative animate-fadeInUp">
            <h3 className="text-lg font-bold text-gray-800 mb-4">Filtrar Pagos</h3>
            <ModernDatePicker
              value={tempStartDate}
              onChange={setTempStartDate}
              label="Fecha inicio"
            />
            <ModernDatePicker
              value={tempEndDate}
              onChange={setTempEndDate}
              label="Fecha fin"
            />
            <div className="mt-3">
              <PatientSelect
                value={tempPatientId}
                onChange={setTempPatientId}
                patients={patients}
              />
            </div>
            <div className="mt-3">
              <PaymentMethodSelect value={tempMethod} onChange={setTempMethod} />
            </div>
            <div className="mt-3">
              <StatusSelect value={tempStatus} onChange={setTempStatus} />
            </div>
            <div className="flex gap-2 mt-6">
              <button
                className="flex-1 bg-gray-100 hover:bg-gray-200 text-gray-700 font-semibold py-2 rounded-lg"
                onClick={() => setShowFilterModal(false)}
              >
                Cancelar
              </button>
              <button
                className="flex-1 bg-red-600 hover:bg-red-700 text-white font-bold py-2 rounded-lg"
                onClick={() => {
                  setStartDate(tempStartDate);
                  setEndDate(tempEndDate);
                  setPatientId(tempPatientId);
                  setMethod(tempMethod);
                  setStatus(tempStatus);
                  setShowFilterModal(false);
                }}
              >
                Aplicar
              </button>
            </div>
          </div>
        </div>
      )}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
        <div className="flex items-center gap-4 flex-1 mb-2 sm:mb-0">
          <div className="bg-red-100 text-red-600 rounded-full p-3">
            <CurrencyDollar size={38} weight="duotone" />
          </div>
          <div>
            <h2 className="text-2xl font-bold text-gray-800 mb-1">Pagos</h2>
            <p className="text-gray-500 text-base font-medium">Gestión de pagos de pacientes.</p>
          </div>
        </div>
        <div className="flex flex-col sm:flex-row gap-2 w-full sm:w-auto items-center">
          <button
            className="bg-white border border-gray-200 hover:bg-gray-100 text-gray-700 font-semibold py-2 px-4 rounded-lg transition-all duration-200 shadow-sm"
            onClick={() => setShowFilterModal(true)}
          >
            Filtrar
          </button>
          <div className="relative w-full max-w-xs">
            <input
              type="text"
              placeholder="Buscar por paciente o referencia..."
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
              <span className="text-gray-600">Total Recaudado</span>
              <span className="text-2xl font-bold text-gray-800">{summary ? `$${summary.total.toLocaleString('es-MX')}` : '---'}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-gray-600">Pagos Pendientes</span>
              <span className="text-2xl font-bold text-red-600">{summary && summary.byStatus && summary.byStatus.pending ? `$${summary.byStatus.pending.toLocaleString('es-MX')}` : '$0'}</span>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-2xl shadow-xl p-6">
          <h3 className="text-lg font-semibold text-gray-800 mb-4">Métodos de Pago</h3>
          <div className="space-y-4">
            <div className="flex justify-between items-center">
              <span className="text-gray-600">Tarjeta de Crédito</span>
              <span className="text-2xl font-bold text-gray-800">{summary && summary.byMethod && summary.byMethod.credit_card && summary.total ? `${Math.round((summary.byMethod.credit_card / summary.total) * 100)}%` : '0%'}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-gray-600">Transferencia</span>
              <span className="text-2xl font-bold text-gray-800">{summary && summary.byMethod && summary.byMethod.transfer && summary.total ? `${Math.round((summary.byMethod.transfer / summary.total) * 100)}%` : '0%'}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-gray-600">Efectivo</span>
              <span className="text-2xl font-bold text-gray-800">{summary && summary.byMethod && summary.byMethod.cash && summary.total ? `${Math.round((summary.byMethod.cash / summary.total) * 100)}%` : '0%'}</span>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-2xl shadow-xl p-6">
          <h3 className="text-lg font-semibold text-gray-800 mb-4">Estadísticas</h3>
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <span className="text-gray-700">Pagos del Mes</span>
              <span className="text-gray-600">{monthStats.count}</span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-gray-700">Promedio por Pago</span>
              <span className="text-gray-600">{monthStats.count ? `$${monthStats.avg.toLocaleString('es-MX', { maximumFractionDigits: 2 })}` : '$0'}</span>
            </div>
          </div>
        </div>
      </div>

      <div className="bg-white rounded-2xl shadow-xl overflow-x-auto border border-gray-200">
        <table className="min-w-full divide-y divide-gray-100">
          <thead className="bg-gray-50 sticky top-0 z-10">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Paciente</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Referencia</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Fecha</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Método</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Monto</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Estado</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Acciones</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr>
                <td colSpan={7} className="px-6 py-4 text-center text-gray-500">
                  Cargando pagos...
                </td>
              </tr>
            ) : filteredPayments.length === 0 ? (
              <tr>
                <td colSpan={7} className="px-6 py-4 text-center text-gray-500">
                  No se encontraron pagos
                </td>
              </tr>
            ) : (
              filteredPayments.map(payment => (
                <tr key={payment.id} className="hover:bg-red-50 transition-all border-b border-gray-100 last:border-0 group">
                  <td className="px-6 py-4 font-medium text-gray-900">{
                    payment.patient
                      ? [payment.patient.name, payment.patient.lastNamePaterno, payment.patient.lastNameMaterno]
                          .filter(Boolean)
                          .join(' ')
                      : '-'
                  }</td>
                  <td className="px-6 py-4 text-gray-600">{payment.reference}</td>
                  <td className="px-6 py-4">{payment.date ? (new Date(payment.date).toLocaleDateString('es-MX')) : '-'}</td>
                  <td className="px-6 py-4">
                    <span className={`px-2 py-1 rounded-full text-xs font-semibold ${
                      payment.method === 'CARD' || payment.method === 'credit_card' ? 'bg-blue-100 text-blue-600' :
                      payment.method === 'TRANSFER' || payment.method === 'transfer' ? 'bg-green-100 text-green-600' :
                      'bg-gray-100 text-gray-600'
                    }`}>
                      {paymentMethodLabel(payment.method)}
                    </span>
                  </td>
                  <td className="px-6 py-4 font-semibold">${payment.amount.toLocaleString()}</td>
                  <td className="px-6 py-4">
                    <span className={`font-semibold px-2 py-0.5 rounded-full text-xs ${paymentStatusClass(payment.status)} inline-flex items-center gap-2`}>
                      {paymentStatusLabel(payment.status)}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-right">
                    <button
                      onClick={() => setSelectedPayment(payment)}
                      className="inline-flex items-center gap-1 text-red-600 hover:text-white hover:bg-red-600 border border-red-200 font-semibold px-3 py-1.5 rounded-lg transition-all duration-150 focus:outline-none focus:ring-2 focus:ring-red-300 group-hover:bg-red-600 group-hover:text-white"
                    >
                      <svg width="20" height="20" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                      Ver
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* Modal de detalles de pago */}
      {selectedPayment && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-lg p-0 relative overflow-hidden animate-fadeInUp">
            {/* Encabezado igual que en Nuevo Pago */}
            <div className="flex items-center gap-3 bg-gradient-to-r from-red-100 to-red-50 px-8 py-6 border-b border-red-100">
              <div className="bg-red-200 text-red-600 rounded-full p-3">
                <CurrencyDollar size={30} className="text-red-500" />
              </div>
              <div className="flex-1">
                <h3 className="text-xl font-bold text-gray-800">Detalle de Pago</h3>
                <div className="text-gray-400 text-sm">Consulta la información del pago</div>
              </div>
              <button
                className="ml-auto text-gray-400 hover:text-red-600 text-2xl font-bold p-1 rounded-full transition-colors focus:outline-none"
                onClick={() => { setSelectedPayment(null); setDeleteError(null); }}
                aria-label="Cerrar"
                type="button"
              >
                <svg width="28" height="28" fill="none" stroke="#e11d48" strokeWidth="2.2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M15 9l-6 6M9 9l6 6"/></svg>
              </button>
            </div>
            <div className="px-8 py-7 space-y-4">
              {deleteError && (
                <div className="mb-4 p-3 bg-red-100 text-red-700 rounded-lg border border-red-300 text-center font-semibold">
                  {deleteError}
                </div>
              )}
              <div className="flex flex-col gap-2">
                <div className="flex justify-between items-center">
                  <span className="text-gray-500 font-medium">Paciente:</span>
                  <span className="font-semibold text-gray-800">{
                    selectedPayment.patient
                      ? [selectedPayment.patient.name, selectedPayment.patient.lastNamePaterno, selectedPayment.patient.lastNameMaterno]
                          .filter(Boolean)
                          .join(' ')
                      : '-'
                  }</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-gray-500 font-medium">Referencia:</span>
                  <span className="font-semibold text-gray-800">{selectedPayment.reference || '-'}</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-gray-500 font-medium">Fecha:</span>
                  <span className="font-semibold text-gray-800">{selectedPayment.date ? (new Date(selectedPayment.date).toLocaleString('es-MX')) : '-'}</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-gray-500 font-medium">Método:</span>
                  <span className="font-semibold text-gray-800">{paymentMethodLabel(selectedPayment.method)}</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-gray-500 font-medium">Monto:</span>
                  <span className="font-semibold text-gray-800">${selectedPayment.amount.toLocaleString()}</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-gray-500 font-medium">Estado:</span>
                  <span className={`font-semibold px-2 py-0.5 rounded-full text-xs ${paymentStatusClass(selectedPayment.status)} inline-flex items-center gap-2`}>
                    {paymentStatusLabel(selectedPayment.status)}
                    <button
                      className="ml-1 p-1 rounded hover:bg-gray-100 text-gray-500 hover:text-red-600 focus:outline-none"
                      onClick={e => {
                        setShowEstadoEdit(true);
                        setAnchorEl(e.currentTarget);
                      }}
                      title="Editar estado"
                      type="button"
                      ref={lapizRef}
                    >
                      <PencilSimple size={18} />
                    </button>
                  </span>
                </div>
                {showEstadoEdit && (
                  <EstadoPagoDropdown
                    payment={selectedPayment}
                    onStatusChange={fetchPayments}
                    onClose={() => setShowEstadoEdit(false)}
                    confirmChange
                    anchorEl={anchorEl}
                  />
                )}
                <div className="flex justify-between items-center">
                  <span className="text-gray-500 font-medium">Descripción:</span>
                  <span className="font-semibold text-gray-800">{selectedPayment.description || '-'}</span>
                </div>
              </div>
              <div className="flex justify-end gap-2 mt-6">
                <button
                  className="flex items-center gap-2 bg-red-100 text-red-700 border border-red-200 px-4 py-2 rounded-lg font-bold hover:bg-red-200 transition-all"
                  onClick={() => setShowDeleteConfirm(true)}
                  disabled={deleting}
                  type="button"
                >
                  <Trash size={20} /> Eliminar
                </button>
              </div>
            </div>
            {/* Confirmación de eliminación */}
            {showDeleteConfirm && (
              <div className="absolute inset-0 flex items-center justify-center bg-black/40 z-50">
                <div className="bg-white rounded-2xl shadow-xl p-8 flex flex-col items-center">
                  <Trash size={40} className="text-red-500 mb-2" />
                  <div className="text-lg font-bold text-gray-800 mb-2">¿Eliminar este pago?</div>
                  <div className="text-gray-500 mb-4">Esta acción no se puede deshacer.</div>
                  <div className="flex gap-3">
                    <button
                      className="bg-gray-100 hover:bg-gray-200 text-gray-700 font-semibold py-2 px-4 rounded-lg"
                      onClick={() => setShowDeleteConfirm(false)}
                      disabled={deleting}
                    >
                      Cancelar
                    </button>
                    <button
                      className="bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-lg flex items-center gap-2"
                      onClick={handleDeletePayment}
                      disabled={deleting}
                    >
                      {deleting ? 'Eliminando...' : (<><Trash size={18} /> Eliminar</>)}
                    </button>
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>
      )}
    </DashboardLayout>
  );
};

export default Payments;
