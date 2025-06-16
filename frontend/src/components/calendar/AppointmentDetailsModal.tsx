import React from 'react';
import { User, Phone, CalendarBlank, Clock, X, WarningCircle } from 'phosphor-react';

interface AppointmentDetailsModalProps {
  visible: boolean;
  appointment: any;
  onClose: () => void;
  onDelete: () => void;
  onCancel: () => void;
  onReschedule: () => void;
}

const AppointmentDetailsModal: React.FC<AppointmentDetailsModalProps> = ({
  visible,
  appointment,
  onClose,
  onDelete,
  onCancel,
  onReschedule,
}) => {
  if (!visible || !appointment) return null;
  const { patient, date, endDate, duration, doctor, service, treatment, notes } = appointment;
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
      <div className="bg-white rounded-3xl shadow-2xl w-full max-w-lg p-0 relative overflow-hidden animate-fadeInUp">
        <div className="flex items-center gap-3 bg-gradient-to-r from-red-100 to-red-50 px-8 py-6 border-b border-red-100">
          <div className="bg-red-200 text-red-600 rounded-full p-3">
            <Clock size={30} weight="duotone" />
          </div>
          <div className="flex-1">
            <h3 className="text-xl font-bold text-gray-800">Detalles de la cita</h3>
            <div className="text-gray-400 text-sm">Puedes reagendar, cancelar o eliminar la cita</div>
          </div>
          <button
            className="ml-auto text-gray-400 hover:text-red-600 text-2xl font-bold p-1 rounded-full transition-colors focus:outline-none focus:ring-2 focus:ring-red-200"
            onClick={onClose}
            aria-label="Cerrar"
            type="button"
          >
            <svg width="28" height="28" fill="none" stroke="#e11d48" strokeWidth="2.2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M15 9l-6 6M9 9l6 6"/></svg>
          </button>
        </div>
        <div className="space-y-3 px-8 py-7">
          {/* Datos principales */}
          <div className="flex flex-col gap-1">
            <div className="flex items-center gap-2">
              <User size={20} weight="bold" className="text-red-600" />
              <span className="font-medium">
                {patient?.name}
                {patient?.lastNamePaterno ? ' ' + patient.lastNamePaterno : ''}
                {patient?.lastNameMaterno ? ' ' + patient.lastNameMaterno : ''}
              </span>
            </div>
            <div className="flex items-center gap-2">
              <Phone size={20} weight="bold" className="text-red-600" />
              <span>{patient?.phone || 'No registrado'}</span>
            </div>
            <div className="flex items-center gap-2">
              <CalendarBlank size={20} weight="bold" className="text-red-600" />
              <span>{date ? new Date(date).toLocaleDateString('es-MX', { year: 'numeric', month: 'long', day: 'numeric' }) : '-'}</span>
            </div>
            <div className="flex items-center gap-2">
              <Clock size={20} weight="bold" className="text-red-600" />
              <span>
                {date ? new Date(date).toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' }) : '-'}
                {endDate && (
                  <>
                    {' - '}
                    {new Date(endDate).toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' })}
                    {' '}
                    <span className="text-gray-500 text-xs">(
                      {duration ? `${duration} min` : (() => {
                        if (date && endDate) {
                          const start = new Date(date);
                          const end = new Date(endDate);
                          const diff = Math.round((end.getTime() - start.getTime()) / 60000);
                          return `${diff} min`;
                        }
                        return '';
                      })()}
                    )</span>
                  </>
                )}
              </span>
            </div>
          </div>
          {/* Doctor, Tratamiento, Notas */}
          <div className="pt-2">
            <span className="font-medium">Doctor:</span>
            <p className="text-gray-600">{doctor || 'No asignado'}</p>
          </div>
          <div className="pt-2">
            <span className="font-medium">Tratamiento:</span>
            <div className="flex items-center gap-2">
              {service?.color && (
                <span className="inline-block w-4 h-4 rounded-full border border-gray-200" style={{ background: service.color }}></span>
              )}
              <span className="text-gray-800 break-words whitespace-pre-line">
                {service?.name || 'No especificado'}
              </span>
            </div>
            {treatment && (
              <p className="text-gray-600 text-xs mt-1">{treatment}</p>
            )}
          </div>
          <div className="pt-2">
            <span className="font-medium">Notas:</span>
            <p className="text-gray-600">{notes || 'Sin notas'}</p>
          </div>
          <div className="flex flex-col gap-2 mt-4">
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-2">
              <button
                onClick={onReschedule}
                className="flex items-center justify-center gap-1 px-2.5 py-1.5 bg-blue-100 text-blue-700 rounded-lg shadow-sm hover:bg-blue-200 transition-all font-medium text-sm focus:outline-none focus:ring-2 focus:ring-blue-200"
              >
                <Clock size={16} weight='bold' /> Reagendar
              </button>
              <button
                onClick={onDelete}
                className="flex items-center justify-center gap-1 px-2.5 py-1.5 bg-red-500 text-white rounded-lg shadow-sm hover:bg-red-600 transition-all font-medium text-sm focus:outline-none focus:ring-2 focus:ring-red-200"
              >
                <X size={16} weight='bold' /> Eliminar
              </button>
              <button
                onClick={onCancel}
                className="flex items-center justify-center gap-1 px-2.5 py-1.5 bg-yellow-400 text-yellow-900 rounded-lg shadow-sm hover:bg-yellow-500 transition-all font-medium text-sm focus:outline-none focus:ring-2 focus:ring-yellow-200"
              >
                <WarningCircle size={16} weight='bold' /> Cancelar cita
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AppointmentDetailsModal; 