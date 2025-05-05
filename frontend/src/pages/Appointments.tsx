import React, { useEffect, useState } from 'react';
import DashboardLayout from '../components/DashboardLayout';
import api from '../services/api';
import { CalendarBlank } from 'phosphor-react';
import AddAppointmentModal from '../components/AddAppointmentModal';
import CalendarAppointments from './CalendarAppointments';
import { Appointment } from '../types/appointment';
import ConfirmDeleteModal from '../components/ConfirmDeleteModal';

const Appointments: React.FC = () => {
  const [appointments, setAppointments] = useState<Appointment[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [filter, setFilter] = useState<'todas' | 'hoy' | 'pasadas' | 'proximas'>('todas');
  const [showCalendar, setShowCalendar] = useState(() => {
    const stored = localStorage.getItem('showCalendar');
    return stored ? stored === 'true' : false;
  });
  const [deleteModalOpen, setDeleteModalOpen] = useState(false);
  const [appointmentToDelete, setAppointmentToDelete] = useState<Appointment | null>(null);

  useEffect(() => {
    api.get('/appointments')
      .then(res => setAppointments(res.data))
      .finally(() => setLoading(false));
  }, []);

  // Guardar en localStorage cuando cambie showCalendar
  useEffect(() => {
    localStorage.setItem('showCalendar', showCalendar.toString());
  }, [showCalendar]);

  // Búsqueda por paciente, fecha, estado o nota
  const filteredAppointments = appointments.filter(a => {
    const q = search.toLowerCase();
    const today = new Date();
    const apptDate = new Date(a.date);
    let matchFilter = true;
    if (filter === 'hoy') {
      matchFilter = apptDate.toDateString() === today.toDateString();
    } else if (filter === 'pasadas') {
      matchFilter = apptDate < today && apptDate.toDateString() !== today.toDateString();
    } else if (filter === 'proximas') {
      matchFilter = apptDate > today && apptDate.toDateString() !== today.toDateString();
    }
    return (
      matchFilter && (
        a.patient?.name?.toLowerCase().includes(q) ||
        a.status?.toLowerCase().includes(q) ||
        a.notes?.toLowerCase().includes(q) ||
        new Date(a.date).toLocaleDateString().includes(q)
      )
    );
  });

  // Eliminar cita
  const handleDelete = async (id: string) => {
    const appointment = appointments.find(a => a.id === id);
    setAppointmentToDelete(appointment || null);
    setDeleteModalOpen(true);
  };

  const confirmDelete = async () => {
    if (appointmentToDelete) {
      await api.delete(`/appointments/${appointmentToDelete.id}`);
      setAppointments(prev => prev.filter(a => a.id !== appointmentToDelete.id));
      setDeleteModalOpen(false);
      setAppointmentToDelete(null);
    }
  };

  const cancelDelete = () => {
    setDeleteModalOpen(false);
    setAppointmentToDelete(null);
  };

  // Mostrar detalles de la cita
  const handleShowDetails = (appointment: Appointment) => {
    alert(`Detalles de la cita:\nPaciente: ${appointment.patient?.name}\nFecha: ${new Date(appointment.date).toLocaleString()}\nEstado: ${appointment.status}\nNotas: ${appointment.notes || 'Sin notas'}`);
  };

  return (
    <DashboardLayout>
      <ConfirmDeleteModal
        open={deleteModalOpen}
        onClose={cancelDelete}
        onConfirm={confirmDelete}
        patientName={appointmentToDelete?.patient?.name}
        appointmentDate={appointmentToDelete ? new Date(appointmentToDelete.date).toLocaleString() : ''}
      />
      <div className="flex flex-col gap-2 w-full sm:flex-row sm:items-center sm:justify-between sm:gap-2 mb-6">
        <div className="flex items-center gap-4 flex-1 mb-2 sm:mb-0">
          <div className="bg-red-100 text-red-600 rounded-full p-3">
            <CalendarBlank size={38} weight="duotone" />
          </div>
          <div>
            <h2 className="text-2xl font-bold text-gray-800 mb-1">Citas</h2>
            <p className="text-gray-500 text-base font-medium">Gestión de las citas agendadas en la clínica.</p>
          </div>
        </div>
        <div className="flex flex-col gap-2 w-full sm:flex-row sm:items-center sm:w-auto">
          {/* Filtros solo si NO está la vista calendario */}
          {!showCalendar && (
            <div className="flex gap-2 w-full sm:w-auto">
              <button className={`flex-1 sm:flex-none py-2 px-3 rounded-lg text-xs font-bold border transition-all duration-150 ${filter==='todas' ? 'bg-red-600 text-white border-red-600' : 'bg-white border-gray-200 text-gray-600 hover:border-red-300'}`} onClick={() => setFilter('todas')}>Todas</button>
              <button className={`flex-1 sm:flex-none py-2 px-3 rounded-lg text-xs font-bold border transition-all duration-150 ${filter==='hoy' ? 'bg-red-600 text-white border-red-600' : 'bg-white border-gray-200 text-gray-600 hover:border-red-300'}`} onClick={() => setFilter('hoy')}>Hoy</button>
              <button className={`flex-1 sm:flex-none py-2 px-3 rounded-lg text-xs font-bold border transition-all duration-150 ${filter==='proximas' ? 'bg-red-600 text-white border-red-600' : 'bg-white border-gray-200 text-gray-600 hover:border-red-300'}`} onClick={() => setFilter('proximas')}>Próximas</button>
              <button className={`flex-1 sm:flex-none py-2 px-3 rounded-lg text-xs font-bold border transition-all duration-150 ${filter==='pasadas' ? 'bg-red-600 text-white border-red-600' : 'bg-white border-gray-200 text-gray-600 hover:border-red-300'}`} onClick={() => setFilter('pasadas')}>Pasadas</button>
            </div>
          )}
          <div className="relative w-full sm:w-auto sm:max-w-xs">
            <input
              type="text"
              placeholder="Buscar por paciente, fecha, estado o nota..."
              className="w-full pl-12 pr-4 py-2 rounded-xl border-2 border-gray-200 focus:border-red-400 focus:ring-2 focus:ring-red-100 text-gray-700 bg-white placeholder-gray-400"
              value={search}
              onChange={e => setSearch(e.target.value)}
              autoComplete="off"
              spellCheck={false}
            />
            <span className="absolute left-4 top-1/2 -translate-y-1/2 text-red-400 pointer-events-none">
              <svg width="22" height="22" fill="none" stroke="currentColor" strokeWidth="2.2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="M21 21l-2-2"/></svg>
            </span>
            {search && (
              <button
                type="button"
                className="absolute right-2 top-1/2 -translate-y-1/2 text-gray-300 hover:text-red-400 text-xl px-1 focus:outline-none"
                onClick={() => setSearch('')}
                tabIndex={-1}
                aria-label="Limpiar búsqueda"
              >
                ×
              </button>
            )}
          </div>
          <div className="flex gap-2 w-full sm:w-auto">
            <button
              className={`py-2 px-3 rounded-lg text-xs font-bold border transition-all duration-150 border-red-200 text-red-600 bg-white ${showCalendar ? 'ring-2 ring-red-300 scale-105' : ''}`}
              onClick={() => setShowCalendar(c => !c)}
              type="button"
            >
              {showCalendar ? 'Vista Lista' : 'Vista Calendario'}
            </button>
            <button
              className="bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-lg transition-all duration-200 ml-0 sm:ml-2 whitespace-nowrap text-base"
              style={{ minHeight: '40px', minWidth: 'auto', fontSize: '1rem', paddingTop: '0.5rem', paddingBottom: '0.5rem', paddingLeft: '1rem', paddingRight: '1rem' }}
              onClick={() => setShowModal(true)}
            >
              + Nueva Cita
            </button>
          </div>
        </div>
      </div>
      {showModal && (
        <AddAppointmentModal onClose={() => setShowModal(false)} onSuccess={() => {
          setShowModal(false);
          setLoading(true);
          api.get('/appointments')
            .then(res => setAppointments(res.data))
            .finally(() => setLoading(false));
        }} appointments={appointments} />
      )}
      {showCalendar && (
        <CalendarAppointments />
      )}
      {loading ? (
        <div className="bg-white rounded-2xl p-8 text-center text-gray-400">
          <CalendarBlank size={64} weight="duotone" className="mx-auto mb-2" />
          <div className="text-lg font-semibold mb-2">Cargando citas...</div>
        </div>
      ) : filteredAppointments.length === 0 && !showCalendar ? (
        <div className="bg-white rounded-2xl p-8 text-center text-gray-400">
          <CalendarBlank size={64} weight="duotone" className="mx-auto mb-2" />
          <div className="text-lg font-semibold mb-2">No se encontraron citas</div>
          <div className="mb-4">Prueba ajustando tu búsqueda o agenda una nueva cita.</div>
        </div>
      ) : (
        !showCalendar && (
          <div className="bg-white rounded-xl border border-gray-200 p-0 mt-8 overflow-x-auto">
            {/* Vista de tabla en escritorio, tarjetas en móvil */}
            <div className="block md:hidden">
              {filteredAppointments.map(a => (
                <div key={a.id} className="mb-4 border-b last:border-0 border-gray-100 p-4 rounded-lg shadow-sm bg-gray-50">
                  <div className="font-bold text-lg text-red-700 mb-1">{a.patient?.name || '-'}</div>
                  <div className="text-sm text-gray-600 mb-1">{new Date(a.date).toLocaleString()}</div>
                  <div className="mb-1">
                    <span className={`inline-block px-3 py-1 rounded-full text-xs font-bold ${
                      a.status === 'pendiente'
                        ? 'bg-yellow-100 text-yellow-800'
                        : a.status === 'confirmada'
                          ? 'bg-green-100 text-green-700'
                          : a.status === 'cancelada'
                            ? 'bg-red-100 text-red-700'
                            : 'bg-gray-100 text-gray-500'
                    }`}>
                      {a.status.charAt(0).toUpperCase() + a.status.slice(1)}
                    </span>
                  </div>
                  <div className="text-xs text-gray-500 mb-2">{a.notes || <span className="italic text-gray-300">Sin notas</span>}</div>
                  <div className="flex gap-2">
                    <button
                      className="text-gray-500 hover:text-red-600 p-2 rounded-full focus:outline-none"
                      title="Ver detalles"
                      onClick={() => handleShowDetails(a)}
                    >
                      <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><circle cx="5" cy="12" r="2"/><circle cx="12" cy="12" r="2"/><circle cx="19" cy="12" r="2"/></svg>
                    </button>
                    <button
                      className="text-red-600 hover:text-red-800 font-bold p-2 rounded-full flex items-center justify-center"
                      style={{ minWidth: 40 }}
                      onClick={() => handleDelete(a.id)}
                      title="Eliminar cita"
                    >
                      <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6M1 7h22M8 7V5a2 2 0 012-2h2a2 2 0 012 2v2" /></svg>
                    </button>
                  </div>
                </div>
              ))}
            </div>
            <table className="hidden md:table min-w-full divide-y divide-gray-100">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Paciente</th>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Fecha y hora</th>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Estado</th>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Notas</th>
                  <th className="px-6 py-3 text-center text-xs font-semibold text-gray-500 uppercase">Acciones</th>
                </tr>
              </thead>
              <tbody>
                {filteredAppointments.map(a => (
                  <tr key={a.id} className="hover:bg-red-50 transition-all border-b border-gray-100 last:border-0 group">
                    <td className="px-6 py-4 font-medium text-gray-900">{a.patient?.name || '-'}</td>
                    <td className="px-6 py-4">{new Date(a.date).toLocaleString()}</td>
                    <td className="px-6 py-4">
                      <span className={`inline-block px-3 py-1 rounded-full text-xs font-bold ${
                        a.status === 'pendiente' 
                          ? 'bg-yellow-100 text-yellow-800' 
                          : a.status === 'confirmada' 
                            ? 'bg-green-100 text-green-700' 
                            : a.status === 'cancelada' 
                              ? 'bg-red-100 text-red-700' 
                              : 'bg-gray-100 text-gray-500'
                      }`}>
                        {a.status.charAt(0).toUpperCase() + a.status.slice(1)}
                      </span>
                    </td>
                    <td className="px-6 py-4">{a.notes || <span className="italic text-gray-300">Sin notas</span>}</td>
                    <td className="px-6 py-4 w-24 align-middle">
                      <div className="flex items-center justify-center gap-2">
                        <button
                          className="text-gray-500 hover:text-red-600 p-2 rounded-full focus:outline-none"
                          title="Ver detalles"
                          onClick={() => handleShowDetails(a)}
                        >
                          <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><circle cx="5" cy="12" r="2"/><circle cx="12" cy="12" r="2"/><circle cx="19" cy="12" r="2"/></svg>
                        </button>
                        <button
                          className="text-red-600 hover:text-red-800 font-bold p-2 rounded-full flex items-center justify-center"
                          style={{ minWidth: 40 }}
                          onClick={() => handleDelete(a.id)}
                          title="Eliminar cita"
                        >
                          <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6M1 7h22M8 7V5a2 2 0 012-2h2a2 2 0 012 2v2" /></svg>
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )
      )}
    </DashboardLayout>
  );
};

export default Appointments;
