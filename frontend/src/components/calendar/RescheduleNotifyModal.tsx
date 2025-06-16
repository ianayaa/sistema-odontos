import React from 'react';
import { Clock } from 'phosphor-react';

interface RescheduleNotifyModalProps {
  visible: boolean;
  event?: any;
  newDate?: Date | null;
  onNotify: (shouldNotify: boolean) => void;
  onClose: () => void;
}

const RescheduleNotifyModal: React.FC<RescheduleNotifyModalProps> = ({
  visible,
  event,
  newDate,
  onNotify,
  onClose,
}) => {
  if (!visible || !event) return null;
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
      <div className="bg-white rounded-3xl shadow-2xl w-full max-w-md p-0 relative overflow-hidden animate-fadeInUp">
        <div className="flex items-center gap-3 bg-gradient-to-r from-red-100 to-red-50 px-8 py-6 border-b border-red-100">
          <div className="bg-red-200 text-red-600 rounded-full p-3">
            <Clock size={30} weight="duotone" />
          </div>
          <div className="flex-1">
            <h3 className="text-xl font-bold text-gray-800">Cita reagendada</h3>
            <div className="text-gray-400 text-sm">¿Desea notificar al paciente sobre el cambio?</div>
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
        <div className="px-8 py-7">
          <div className="flex flex-col gap-4">
            <div className="flex items-center gap-3 mb-4">
              {event.service?.color && (
                <span className="inline-block w-6 h-6 rounded-full border-2 border-gray-200" style={{ background: event.service.color }}></span>
              )}
              <span className="font-semibold text-gray-700 text-base">{event.service?.name || 'Sin servicio'}</span>
            </div>
            <div className="text-gray-700 text-sm mb-2">
              <b>Paciente:</b> {event.patient?.name} {event.patient?.lastNamePaterno || ''} {event.patient?.lastNameMaterno || ''}
            </div>
            <div className="text-gray-700 text-sm mb-2">
              <b>Fecha:</b> {newDate ? new Date(newDate).toLocaleString('es-MX') : (event.date ? new Date(event.date).toLocaleString('es-MX') : '-')}
            </div>
            <div className="text-gray-700 text-sm mb-2">
              <b>Doctor:</b> {event.doctor || 'No asignado'}
            </div>
            <button
              className="w-full flex items-center justify-center gap-2 px-4 py-2 rounded-xl bg-red-600 text-white font-bold text-base shadow hover:bg-red-700 transition-all focus:outline-none focus:ring-2 focus:ring-red-200"
              onClick={() => onNotify(true)}
            >
              <span>Notificar paciente</span>
            </button>
            <button
              className="w-full flex items-center justify-center gap-2 px-4 py-2 rounded-xl bg-gray-100 text-gray-700 font-bold text-base shadow hover:bg-gray-200 transition-all focus:outline-none focus:ring-2 focus:ring-gray-200"
              onClick={() => onNotify(false)}
            >
              <span>No notificar</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default RescheduleNotifyModal; 