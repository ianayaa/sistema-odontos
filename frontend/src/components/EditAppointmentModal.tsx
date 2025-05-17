import React, { useState, useEffect } from 'react';
import api, { getServices } from '../services/api';
import { NotePencil, Clock, Timer } from 'phosphor-react';
import ModernDatePicker from './ModernDatePicker';
import { Select } from 'antd';
import 'antd/dist/reset.css';
import StatusSelect from './StatusSelect';
import { createDateWithTime, toZonedDate } from '../utils/dateUtils';

interface EditAppointmentModalProps {
  onClose: () => void;
  onSuccess: () => void;
  appointment: any;
  appointments: any[];
  blockedHours?: { date: string; start: string; end: string }[];
}

const durationOptions = [
  { label: '30 minutos', value: 30 },
  { label: '45 minutos', value: 45 },
  { label: '1 hora', value: 60 },
  { label: '1.5 horas', value: 90 },
  { label: '2 horas', value: 120 },
];

const generateTimeOptions = (start = 8, end = 20, interval = 15) => {
  const options = [];
  for (let h = start; h < end; h++) {
    for (let m = 0; m < 60; m += interval) {
      const hour = h.toString().padStart(2, '0');
      const min = m.toString().padStart(2, '0');
      options.push(`${hour}:${min}`);
    }
  }
  return options;
};

const EditAppointmentModal: React.FC<EditAppointmentModalProps> = ({ onClose, onSuccess, appointment, appointments, blockedHours = [] }) => {
  const [form, setForm] = useState({
    date: appointment.date ? new Date(appointment.date) : null,
    status: appointment.status || 'pendiente',
    notes: appointment.notes || '',
    serviceId: appointment.serviceId || '',
  });
  const [services, setServices] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [hour, setHour] = useState(() => {
    if (!appointment.date) return '';
    const d = new Date(appointment.date);
    return d.toTimeString().slice(0,5);
  });
  const [duration, setDuration] = useState(appointment.duration || 60);
  const timeOptions = generateTimeOptions();

  useEffect(() => {
    getServices()
      .then(setServices)
      .catch(() => setServices([]));
  }, []);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    if (!form.date || !hour || !form.serviceId) {
      setError('Selecciona una fecha, una hora y un servicio.');
      setLoading(false);
      return;
    }

    const dateWithTime = createDateWithTime(form.date, hour);
    const endDate = new Date(dateWithTime.getTime() + duration * 60000);
    
    let status = 'SCHEDULED';
    if (form.status === 'completada') status = 'COMPLETED';
    else if (form.status === 'cancelada') status = 'CANCELLED';
    else if (form.status === 'reagendada') status = 'RESCHEDULED';

    try {
      await api.put(`/appointments/${appointment.id}`, {
        date: dateWithTime.toISOString(),
        endDate: endDate.toISOString(),
        status,
        notes: form.notes,
        duration,
        serviceId: form.serviceId,
      });
      onSuccess();
    } catch (err: any) {
      setError('Ocurrió un error al actualizar la cita.');
    } finally {
      setLoading(false);
    }
  };

  // Filtrar horas disponibles según citas existentes y bloqueos
  const getAvailableTimeOptions = () => {
    if (!form.date) return timeOptions;
    const selectedDate = new Date(form.date);
    const dateStr = selectedDate.toISOString().split('T')[0];
    // Filtrar por bloqueos
    const bloqueosFecha = blockedHours.filter(b => b.date === dateStr);
    return timeOptions.filter(opt => {
      const [h, m] = opt.split(':');
      const start = new Date(selectedDate);
      start.setHours(Number(h), Number(m), 0, 0);
      const end = new Date(start.getTime() + duration * 60000);
      // No traslapa con ninguna cita existente (excepto la actual)
      const traslapaCita = appointments.some(appt => {
        if (appt.id === appointment.id) return false;
        const apptStart = new Date(appt.date);
        const apptEnd = appt.endDate ? new Date(appt.endDate) : new Date(apptStart.getTime() + (appt.duration || 60) * 60000);
        return start < apptEnd && end > apptStart;
      });
      if (traslapaCita) return false;
      // No traslapa con bloqueos
      const startMin = Number(h) * 60 + Number(m);
      const endMin = startMin + duration;
      const traslapaBloqueo = bloqueosFecha.some(b => {
        const [bh, bm] = b.start.split(':').map(Number);
        const [eh, em] = b.end.split(':').map(Number);
        const blockStart = bh * 60 + bm;
        const blockEnd = eh * 60 + em;
        return startMin < blockEnd && endMin > blockStart;
      });
      return !traslapaBloqueo;
    });
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
      <div className="bg-white rounded-3xl shadow-2xl w-full max-w-lg p-0 relative overflow-hidden animate-fadeInUp">
        <div className="flex items-center gap-3 bg-gradient-to-r from-red-100 to-red-50 px-8 py-6 border-b border-red-100">
          <div className="bg-red-200 text-red-600 rounded-full p-3">
            <Clock size={30} weight="duotone" />
          </div>
          <div className="flex-1">
            <h3 className="text-xl font-bold text-gray-800">Editar/Reagendar cita</h3>
            <div className="text-gray-400 text-sm">Modifica los datos necesarios y guarda los cambios</div>
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
        <form onSubmit={handleSubmit} className="space-y-4 px-8 py-7">
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Paciente</label>
            <div className="w-full border border-gray-200 rounded-xl px-4 py-2 bg-gray-100 text-gray-700 select-none">
              {appointment.patient?.name} {appointment.patient?.lastNamePaterno || ''} {appointment.patient?.lastNameMaterno || ''}
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Fecha</label>
            <ModernDatePicker
              value={form.date}
              onChange={date => setForm(f => ({ ...f, date }))}
            />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1 mt-2">Duración</label>
            <Select
              className="w-full"
              popupClassName="z-50"
              value={duration}
              onChange={value => setDuration(value)}
              disabled={loading}
              optionLabelProp="label"
              dropdownStyle={{ borderRadius: 12, boxShadow: '0 4px 24px 0 rgba(0,0,0,0.10)' }}
              style={{ width: '100%', borderRadius: 12 }}
            >
              {durationOptions.map(opt => (
                <Select.Option key={opt.value} value={opt.value} label={
                  <span className="flex items-center gap-2">
                    <Timer size={18} className="text-red-400" weight="duotone" />
                    {opt.label}
                  </span>
                }>
                  <span className="flex items-center gap-2">
                    <Timer size={18} className="text-red-400" weight="duotone" />
                    {opt.label}
                  </span>
                </Select.Option>
              ))}
            </Select>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1 mt-2">Hora</label>
            <Select
              className="w-full"
              popupClassName="z-50"
              value={hour || undefined}
              onChange={value => setHour(value)}
              disabled={loading || !form.date}
              optionLabelProp="label"
              dropdownStyle={{ borderRadius: 12, boxShadow: '0 4px 24px 0 rgba(0,0,0,0.10)' }}
              style={{ width: '100%', borderRadius: 12 }}
            >
              <Select.Option value="" label={<span className="flex items-center gap-2"><Clock size={18} className="text-red-400" weight="duotone" />Selecciona hora</span>}>
                <span className="flex items-center gap-2"><Clock size={18} className="text-red-400" weight="duotone" />Selecciona hora</span>
              </Select.Option>
              {getAvailableTimeOptions().map(opt => (
                <Select.Option key={opt} value={opt} label={
                  <span className="flex items-center gap-2">
                    <Clock size={18} className="text-red-400" weight="duotone" />
                    {opt}
                  </span>
                }>
                  <span className="flex items-center gap-2">
                    <Clock size={18} className="text-red-400" weight="duotone" />
                    {opt}
                  </span>
                </Select.Option>
              ))}
            </Select>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Servicio</label>
            <Select
              className="w-full"
              popupClassName="z-50"
              value={form.serviceId || undefined}
              onChange={value => setForm(f => ({ ...f, serviceId: value }))}
              disabled={loading}
              optionLabelProp="label"
              dropdownStyle={{ borderRadius: 12, boxShadow: '0 4px 24px 0 rgba(0,0,0,0.10)' }}
              style={{ width: '100%', borderRadius: 12 }}
              showSearch
              placeholder="Selecciona un servicio"
              filterOption={(input, option) =>
                (option?.label as string).toLowerCase().includes(input.toLowerCase())
              }
            >
              {services.map(service => (
                <Select.Option key={service.id} value={service.id} label={service.name}>
                  <span className="flex items-center gap-2">
                    {service.name} <span className="text-gray-400 text-xs">({service.type})</span>
                  </span>
                </Select.Option>
              ))}
            </Select>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Estado</label>
            <StatusSelect
              value={form.status}
              onChange={status => setForm(f => ({ ...f, status }))}
              disabled={loading}
            />
          </div>
          <div className="relative">
            <label className="block text-sm font-semibold text-gray-700 mb-1">Notas</label>
            <div className="relative">
              <span className="absolute left-3 top-3 text-red-300">
                <NotePencil size={20} weight="duotone" className="drop-shadow-sm" />
              </span>
              <textarea
                name="notes"
                value={form.notes}
                onChange={handleChange}
                className="w-full border-gray-200 rounded-xl pl-10 pr-3 py-2 focus:border-blue-400 focus:ring-2 focus:ring-blue-100 bg-white text-gray-700 resize-none"
                rows={2}
                placeholder="Opcional"
                disabled={loading}
              />
            </div>
          </div>
          {error && <div className="text-red-500 text-sm font-medium mt-2">{error}</div>}
          <button
            type="submit"
            className="w-full bg-gradient-to-r from-red-600 to-red-500 hover:from-red-700 hover:to-red-600 text-white font-bold py-2 px-4 rounded-xl transition-all duration-200 shadow-md mt-2 disabled:opacity-60 text-base"
            disabled={loading}
          >
            {loading ? 'Guardando...' : 'Guardar cambios'}
          </button>
        </form>
      </div>
    </div>
  );
};

export default EditAppointmentModal; 