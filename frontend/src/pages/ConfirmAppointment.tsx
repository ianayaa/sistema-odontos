import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import api from '../services/api';
import { CheckCircle, XCircle } from 'phosphor-react';

const ConfirmAppointment: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const [status, setStatus] = useState<'pending' | 'success' | 'error'>('pending');
  const [message, setMessage] = useState('');

  useEffect(() => {
    if (!id) {
      setStatus('error');
      setMessage('ID de cita inválido.');
      return;
    }
    // Llama al backend para confirmar la cita
    api.post(`/appointments/${id}/confirm`)
      .then(() => {
        setStatus('success');
        setMessage('¡Tu cita ha sido confirmada exitosamente!');
      })
      .catch(() => {
        setStatus('error');
        setMessage('No se pudo confirmar la cita. Es posible que ya haya sido confirmada o cancelada.');
      });
  }, [id]);

  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gradient-to-br from-red-50 to-white px-4">
      <div className="bg-white rounded-3xl shadow-2xl max-w-md w-full p-8 border border-red-100 flex flex-col items-center animate-fadeInUp">
        <div className="bg-red-100 text-red-600 rounded-full p-4 mb-4">
          {status === 'success' ? (
            <CheckCircle size={48} weight="duotone" />
          ) : status === 'error' ? (
            <XCircle size={48} weight="duotone" />
          ) : (
            <svg className="animate-spin" width="48" height="48" fill="none" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" stroke="#f87171" strokeWidth="4" opacity="0.2" /><path d="M12 2a10 10 0 0 1 10 10" stroke="#f87171" strokeWidth="4" strokeLinecap="round" /></svg>
          )}
        </div>
        <h2 className="text-2xl font-bold text-gray-800 mb-2 text-center">Odontos Dental Office</h2>
        <div className="text-gray-600 text-center mb-4">{message || 'Confirmando tu cita...'}</div>
        {status === 'success' && (
          <div className="text-green-600 font-semibold text-center mb-2">¡Gracias por confirmar tu cita! Te esperamos.</div>
        )}
        {status === 'error' && (
          <div className="text-red-500 font-semibold text-center mb-2">Por favor, contacta a la clínica si tienes dudas.</div>
        )}
        <a href="/" className="mt-4 text-red-600 hover:underline text-sm">Volver al inicio</a>
      </div>
    </div>
  );
};

export default ConfirmAppointment; 