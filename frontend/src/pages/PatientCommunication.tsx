import React, { useState } from 'react';
import DashboardLayout from '../components/DashboardLayout';
import { ChatCircleText } from 'phosphor-react';
import { Gear } from 'phosphor-react';

interface Message {
  id: string;
  patientName: string;
  type: 'email' | 'sms' | 'whatsapp';
  subject: string;
  date: string;
  status: 'sent' | 'pending' | 'failed';
}

const PatientCommunication: React.FC = () => {
  const [messages, setMessages] = useState<Message[]>([]);
  const [search, setSearch] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [showConfig, setShowConfig] = useState(false);
  const [smsApiKey, setSmsApiKey] = useState('');
  const [whatsappApiKey, setWhatsappApiKey] = useState('');

  const filteredMessages = messages.filter(message => 
    message.patientName.toLowerCase().includes(search.toLowerCase()) ||
    message.subject.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <DashboardLayout>
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
        <div className="flex items-center gap-4 flex-1 mb-2 sm:mb-0">
          <div className="bg-red-100 text-red-600 rounded-full p-3">
            <ChatCircleText size={38} weight="duotone" />
          </div>
          <div>
            <h2 className="text-2xl font-bold text-gray-800 mb-1">Comunicación con Pacientes</h2>
            <p className="text-gray-500 text-base font-medium">Gestión de mensajes y notificaciones.</p>
          </div>
        </div>
        <div className="flex items-center gap-2 w-full sm:w-auto">
          <div className="relative w-full max-w-xs">
            <input
              type="text"
              placeholder="Buscar por paciente o asunto..."
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
            + Nuevo Mensaje
          </button>
          <button
            className="bg-gray-100 hover:bg-gray-200 text-gray-700 font-bold py-2 px-3 rounded-lg ml-2 flex items-center gap-1 border border-gray-300"
            title="Configurar SMS y WhatsApp"
            onClick={() => setShowConfig(true)}
          >
            <Gear size={20} />
            Configuración
          </button>
        </div>
      </div>

      <div className="bg-white rounded-2xl shadow-xl overflow-x-auto border border-gray-200">
        <table className="min-w-full divide-y divide-gray-100">
          <thead className="bg-gray-50 sticky top-0 z-10">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Paciente</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Tipo</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Asunto</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Fecha</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Estado</th>
              <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Acciones</th>
            </tr>
          </thead>
          <tbody>
            {filteredMessages.map(message => (
              <tr key={message.id} className="hover:bg-red-50 transition-all border-b border-gray-100 last:border-0 group">
                <td className="px-6 py-4 font-medium text-gray-900">{message.patientName}</td>
                <td className="px-6 py-4">
                  <span className={`px-2 py-1 rounded-full text-xs font-semibold ${
                    message.type === 'email' ? 'bg-blue-100 text-blue-600' :
                    message.type === 'sms' ? 'bg-green-100 text-green-600' :
                    'bg-green-100 text-green-600'
                  }`}>
                    {message.type.toUpperCase()}
                  </span>
                </td>
                <td className="px-6 py-4">{message.subject}</td>
                <td className="px-6 py-4">{new Date(message.date).toLocaleDateString()}</td>
                <td className="px-6 py-4">
                  <span className={`px-2 py-1 rounded-full text-xs font-semibold ${
                    message.status === 'sent' ? 'bg-green-100 text-green-600' :
                    message.status === 'pending' ? 'bg-yellow-100 text-yellow-600' :
                    'bg-red-100 text-red-600'
                  }`}>
                    {message.status === 'sent' ? 'Enviado' :
                     message.status === 'pending' ? 'Pendiente' : 'Fallido'}
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

      {/* Modal de configuración de SMS y WhatsApp API */}
      {showConfig && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-40">
          <div className="bg-white rounded-xl shadow-2xl p-8 max-w-md w-full relative">
            <button className="absolute top-2 right-2 text-gray-400 hover:text-red-500" onClick={() => setShowConfig(false)}>&times;</button>
            <h3 className="text-lg font-bold mb-4 text-red-700 flex items-center gap-2"><Gear size={22}/> Configuración de APIs</h3>
            <form className="space-y-5">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1">API Key SMS</label>
                <input
                  type="text"
                  className="w-full border border-gray-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
                  placeholder="Ingresa tu API Key de SMS (ej. Twilio)"
                  value={smsApiKey}
                  onChange={e => setSmsApiKey(e.target.value)}
                />
              </div>
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1">API Key WhatsApp</label>
                <input
                  type="text"
                  className="w-full border border-gray-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
                  placeholder="Ingresa tu API Key de WhatsApp Business"
                  value={whatsappApiKey}
                  onChange={e => setWhatsappApiKey(e.target.value)}
                />
              </div>
              <div className="flex justify-end gap-2 pt-4">
                <button
                  type="button"
                  className="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300"
                  onClick={() => setShowConfig(false)}
                >
                  Cancelar
                </button>
                <button
                  type="button"
                  className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700"
                  // Aquí deberías guardar la config en el backend
                  onClick={() => { setShowConfig(false); alert('Configuración guardada (simulado)'); }}
                >
                  Guardar
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </DashboardLayout>
  );
};

export default PatientCommunication;