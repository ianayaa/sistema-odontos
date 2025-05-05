import React, { useState } from 'react';
import DashboardLayout from '../components/DashboardLayout';
import { ChatCircleText } from 'phosphor-react';
import { Gear } from 'phosphor-react';
import { Modal, Select, Input, Radio, Button, message as antdMessage } from 'antd';
import { getPatients } from '../services/api';
import api from '../services/api';
import PatientSelect from '../components/PatientSelect';

interface Message {
  id: string;
  patientName: string;
  type: 'email' | 'sms' | 'whatsapp';
  subject: string;
  date: string;
  status: 'sent' | 'pending' | 'failed';
}

const { Option } = Select;

const PatientCommunication: React.FC = () => {
  const [messages, setMessages] = useState<Message[]>([]);
  const [search, setSearch] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [showConfig, setShowConfig] = useState(false);
  const [smsApiKey, setSmsApiKey] = useState('');
  const [whatsappApiKey, setWhatsappApiKey] = useState('');
  const [nuevoModal, setNuevoModal] = useState(false);
  const [tipoEnvio, setTipoEnvio] = useState<'individual' | 'masivo'>('individual');
  const [pacientes, setPacientes] = useState<any[]>([]);
  const [destinatario, setDestinatario] = useState<string | null>(null);
  const [canal, setCanal] = useState<'sms' | 'whatsapp'>('sms');
  const [mensaje, setMensaje] = useState('');
  const [enviando, setEnviando] = useState(false);
  const [smsSegmentCost, setSmsSegmentCost] = useState(() => {
    const stored = localStorage.getItem('sms-segment-cost');
    return stored ? parseFloat(stored) : 0.1511;
  });

  const filteredMessages = messages.filter(message => 
    message.patientName.toLowerCase().includes(search.toLowerCase()) ||
    message.subject.toLowerCase().includes(search.toLowerCase())
  );

  React.useEffect(() => {
    if (showModal) {
      getPatients().then(setPacientes);
    }
  }, [showModal]);

  const handleEnviar = async () => {
    setEnviando(true);
    try {
      if (tipoEnvio === 'individual' && destinatario) {
        await api.post('/messages/send', {
          to: destinatario,
          channel: canal,
          message: mensaje,
        });
      } else if (tipoEnvio === 'masivo') {
        await api.post('/messages/send-bulk', {
          channel: canal,
          message: mensaje,
        });
      }
      antdMessage.success('Mensaje enviado correctamente');
      setMensaje('');
      setDestinatario(null);
      setShowModal(false);
    } catch (e) {
      antdMessage.error('Error al enviar el mensaje');
    }
    setEnviando(false);
  };

  // Función para detectar encoding y calcular segmentos
  function getMessageEncodingAndSegments(text: string) {
    // GSM 7-bit chars
    const gsm7 =
      '@£$¥èéùìòÇ\nØø\rÅåΔ_ΦΓΛΩΠΨΣΘΞ\u0020!"#¤%&' +
      "()*+,-./0123456789:;<=>?¡ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÑÜ§¿abcdefghijklmnopqrstuvwxyzäöñüà";
    let isGsm7 = true;
    for (let i = 0; i < text.length; i++) {
      if (!gsm7.includes(text[i])) {
        isGsm7 = false;
        break;
      }
    }
    let encoding = isGsm7 ? 'GSM7' : 'UCS2';
    let perSegment = isGsm7 ? 160 : 70;
    let perSegmentExtra = isGsm7 ? 153 : 67;
    let segments = 1;
    if (text.length > perSegment) {
      segments = Math.ceil((text.length - perSegment) / perSegmentExtra) + 1;
    }
    return { encoding, segments };
  }

  const { encoding, segments } = getMessageEncodingAndSegments(mensaje);
  const destinatariosCount = tipoEnvio === 'masivo' ? pacientes.length : destinatario ? 1 : 0;
  const totalCost = segments * smsSegmentCost * destinatariosCount;

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
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1">Costo por segmento SMS (USD)</label>
                <input
                  type="number"
                  min="0"
                  step="0.0001"
                  className="w-full border border-gray-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-red-100 focus:border-red-400"
                  value={smsSegmentCost}
                  onChange={e => {
                    setSmsSegmentCost(parseFloat(e.target.value));
                    localStorage.setItem('sms-segment-cost', e.target.value);
                  }}
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
                  onClick={() => { setShowConfig(false); antdMessage.success('Configuración guardada'); }}
                >
                  Guardar
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Modal de nuevo mensaje personalizado */}
      {showModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-lg p-0 relative overflow-hidden animate-fadeInUp">
            <div className="flex items-center gap-3 bg-gradient-to-r from-red-100 to-red-50 px-8 py-6 border-b border-red-100">
              <div className="bg-red-200 text-red-600 rounded-full p-3">
                <ChatCircleText size={30} weight="duotone" />
              </div>
              <div className="flex-1">
                <h3 className="text-xl font-bold text-gray-800">Nuevo Mensaje</h3>
                <div className="text-gray-400 text-sm">Envía un mensaje personalizado a uno o varios pacientes</div>
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
            <form onSubmit={e => { e.preventDefault(); handleEnviar(); }} className="space-y-4 px-8 py-7">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1">Tipo de envío</label>
                <div className="flex gap-3">
                  <button type="button" onClick={() => setTipoEnvio('individual')} className={`px-4 py-2 rounded-xl border text-base font-semibold transition-all ${tipoEnvio === 'individual' ? 'bg-red-100 text-red-700 border-red-400' : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50'}`}>A un paciente</button>
                  <button type="button" onClick={() => setTipoEnvio('masivo')} className={`px-4 py-2 rounded-xl border text-base font-semibold transition-all ${tipoEnvio === 'masivo' ? 'bg-red-100 text-red-700 border-red-400' : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50'}`}>A todos los pacientes</button>
                </div>
              </div>
              {tipoEnvio === 'individual' && (
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-1">Paciente</label>
                  <PatientSelect
                    value={destinatario || ''}
                    onChange={setDestinatario}
                    patients={pacientes}
                    disabled={enviando}
                  />
                </div>
              )}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1">Canal</label>
                <div className="flex gap-3">
                  <button type="button" onClick={() => setCanal('sms')} className={`px-4 py-2 rounded-xl border text-base font-semibold transition-all ${canal === 'sms' ? 'bg-red-100 text-red-700 border-red-400' : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50'}`}>SMS</button>
                  <button type="button" onClick={() => setCanal('whatsapp')} className={`px-4 py-2 rounded-xl border text-base font-semibold transition-all ${canal === 'whatsapp' ? 'bg-red-100 text-red-700 border-red-400' : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50'}`}>WhatsApp</button>
                </div>
              </div>
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1">Mensaje</label>
                <textarea
                  rows={4}
                  placeholder="Escribe tu mensaje. Puedes usar {nombre} para personalizar."
                  value={mensaje}
                  onChange={e => setMensaje(e.target.value)}
                  className="w-full rounded-xl border border-gray-300 px-4 py-2 text-base focus:border-red-400 focus:ring-2 focus:ring-red-100"
                  style={{ minHeight: 90 }}
                  disabled={enviando}
                />
                <div className="text-xs text-gray-500 mb-2">Puedes usar <b>{'{nombre}'}</b> para personalizar el mensaje con el nombre del paciente.</div>
              </div>
              {mensaje && (
                <div className="bg-red-50 border border-red-200 rounded-xl p-4 mt-2 mb-2 text-sm flex items-center gap-4 shadow-sm">
                  <div className="bg-red-100 text-red-600 rounded-full p-2 flex items-center justify-center" style={{height: 40, width: 40}}>
                    <ChatCircleText size={24} weight="duotone" />
                  </div>
                  <div className="flex-1">
                    <div className="mb-1 font-semibold text-gray-700">Detalles del mensaje:</div>
                    <div><b>Encoding:</b> {encoding}</div>
                    <div><b>Segmentos:</b> {segments}</div>
                    <div><b>Destinatarios:</b> {destinatariosCount}</div>
                    <div><b>Costo por segmento:</b> ${smsSegmentCost.toFixed(4)} USD</div>
                    <div className="text-red-600 font-bold mt-1">Costo total estimado: ${totalCost.toFixed(4)} USD</div>
                    {encoding === 'UCS2' && <div className="text-yellow-600 mt-1">Advertencia: El mensaje contiene caracteres especiales y usará UCS2 (mayor costo por segmento).</div>}
                  </div>
                </div>
              )}
              <div className="flex justify-end gap-2 mt-4">
                <button
                  type="button"
                  className="bg-gray-200 text-gray-700 rounded-lg px-6 py-2 text-base font-semibold hover:bg-gray-300 border-none"
                  onClick={() => setShowModal(false)}
                  disabled={enviando}
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="bg-red-600 hover:bg-red-700 text-white rounded-lg px-6 py-2 text-base font-bold border-none"
                  disabled={!mensaje || (tipoEnvio === 'individual' && !destinatario) || enviando}
                >
                  {enviando ? 'Enviando...' : 'Enviar'}
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