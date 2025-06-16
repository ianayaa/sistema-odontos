import React, { useState, useRef, useEffect } from 'react';
import DashboardLayout from '../components/DashboardLayout';
import { GearSix, Users, Image, Upload } from 'phosphor-react';
import UserManagement from './UserManagement';
import PatientUserSupport from '../components/PatientUserSupport';
import api, { getClinicConfig, updateClinicConfig } from '../services/api';
import Notification from '../components/Notification';

const Configuracion: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'general' | 'usuarios' | 'pacientes' | 'creditos'>('general');
  const [form, setForm] = useState({
    nombreClinica: '',
    telefono: '',
    direccion: '',
    correo: '',
    horario: '',
    colorPrincipal: '#b91c1c',
    total_estaciones: 2
  });
  const [guardando, setGuardando] = useState(false);
  const [loadingConfig, setLoadingConfig] = useState(true);
  const [notification, setNotification] = useState<{message: string; type: 'success' | 'error'} | null>(null);


  const showNotification = (message: string, type: 'success' | 'error') => {
    setNotification({ message, type });
    setTimeout(() => setNotification(null), 5000);
  };

  useEffect(() => {
    // Cargar la configuración al montar
    getClinicConfig().then(config => {
      setForm({
        nombreClinica: config.nombreClinica || '',
        telefono: config.telefono || '',
        direccion: config.direccion || '',
        correo: config.correo || '',
        horario: config.horario || '',
        colorPrincipal: config.colorPrincipal || '#b91c1c',
        total_estaciones: config.total_estaciones || 2
      });
      setLoadingConfig(false);
    });
  }, []);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setForm({ ...form, [e.target.name]: e.target.type === 'number' ? Number(e.target.value) : e.target.value });
  };



  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setGuardando(true);
    
    try {
      // Preparar los datos para enviar al servidor
      const dataToSend = {
        nombreClinica: form.nombreClinica,
        telefono: form.telefono,
        direccion: form.direccion,
        correo: form.correo,
        horario: form.horario,
        colorPrincipal: form.colorPrincipal,
        total_estaciones: form.total_estaciones
      };

      // Actualizar la configuración
      await updateClinicConfig(dataToSend);
      showNotification('La configuración se ha guardado correctamente', 'success');
      
      // Recargar la configuración para asegurar que todo esté sincronizado
      const config = await getClinicConfig();
      setForm({
        nombreClinica: config.nombreClinica || '',
        telefono: config.telefono || '',
        direccion: config.direccion || '',
        correo: config.correo || '',
        horario: config.horario || '',
        colorPrincipal: config.colorPrincipal || '#b91c1c',
        total_estaciones: config.total_estaciones || 2
      });
      
    } catch (error: any) {
      console.error('Error al guardar la configuración:', error);
      const errorMessage = error?.response?.data?.error || 
                          error?.response?.data?.message || 
                          'Ocurrió un error al guardar la configuración. Por favor, inténtalo de nuevo.';
      showNotification(errorMessage, 'error');
    } finally {
      setGuardando(false);
    }
  };

  return (
    <DashboardLayout>
      <div className="w-full max-w-6xl mx-auto py-12 px-4">
        <div className="flex items-center gap-4 mb-6">
          <div className="bg-red-100 text-red-600 rounded-full p-3">
            <GearSix size={38} weight="duotone" />
          </div>
          <div>
            <h1 className="text-3xl font-extrabold text-red-700 mb-1">Configuración del sistema</h1>
            <p className="text-gray-500 text-base font-medium">Personaliza la información y parámetros de tu clínica.</p>
          </div>
        </div>

        {/* Tabs */}
        <div className="flex gap-4 mb-6 border-b border-gray-200">
          <button
            className={`px-4 py-2 -mb-px border-b-2 font-medium text-sm transition-colors ${
              activeTab === 'general'
                ? 'border-red-600 text-red-700'
                : 'border-transparent text-gray-500 hover:text-red-600'
            }`}
            onClick={() => setActiveTab('general')}
          >
            Configuración General
          </button>
          <button
            className={`px-4 py-2 -mb-px border-b-2 font-medium text-sm transition-colors ${
              activeTab === 'usuarios'
                ? 'border-red-600 text-red-700'
                : 'border-transparent text-gray-500 hover:text-red-600'
            }`}
            onClick={() => setActiveTab('usuarios')}
          >
            Gestión de Usuarios
          </button>
          <button
            className={`px-4 py-2 -mb-px border-b-2 font-medium text-sm transition-colors ${
              activeTab === 'pacientes'
                ? 'border-red-600 text-red-700'
                : 'border-transparent text-gray-500 hover:text-red-600'
            }`}
            onClick={() => setActiveTab('pacientes')}
          >
            Pacientes
          </button>
          <button
            className={`px-4 py-2 -mb-px border-b-2 font-medium text-sm transition-colors ${
              activeTab === 'creditos'
                ? 'border-red-600 text-red-700'
                : 'border-transparent text-gray-500 hover:text-red-600'
            }`}
            onClick={() => setActiveTab('creditos')}
          >
            Créditos y Aviso Legal
          </button>
        </div>

        {/* Contenido de las tabs */}
        {activeTab === 'general' ? (
          loadingConfig ? (
            <div className="bg-white rounded-2xl shadow-xl p-8 text-center text-gray-400">
              <GearSix size={64} weight="duotone" className="mx-auto mb-2" />
              <div className="text-lg font-semibold mb-2">Cargando configuración...</div>
            </div>
          ) : (
            <form className="space-y-7 bg-white p-10 rounded-2xl shadow-xl border border-gray-100" onSubmit={handleSubmit}>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label className="block font-semibold mb-1 text-gray-700">Nombre de la clínica</label>
                  <input type="text" name="nombreClinica" value={form.nombreClinica} onChange={handleChange} className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:border-red-400 focus:ring-2 focus:ring-red-100" />
                </div>
                <div>
                  <label className="block font-semibold mb-1 text-gray-700">Teléfono</label>
                  <input type="text" name="telefono" value={form.telefono} onChange={handleChange} className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:border-red-400 focus:ring-2 focus:ring-red-100" />
                </div>
                <div className="md:col-span-2">
                  <label className="block font-semibold mb-1 text-gray-700">Dirección</label>
                  <textarea name="direccion" value={form.direccion} onChange={handleChange} className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:border-red-400 focus:ring-2 focus:ring-red-100" rows={2} />
                </div>
                <div>
                  <label className="block font-semibold mb-1 text-gray-700">Correo electrónico</label>
                  <input type="email" name="correo" value={form.correo} onChange={handleChange} className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:border-red-400 focus:ring-2 focus:ring-red-100" />
                </div>
                <div>
                  <label className="block font-semibold mb-1 text-gray-700">Horario de atención</label>
                  <input type="text" name="horario" value={form.horario} onChange={handleChange} className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:border-red-400 focus:ring-2 focus:ring-red-100" placeholder="Ej: Lun-Vie 9am-7pm, Sáb 10am-2pm" />
                </div>
                <div>
                  <label className="block font-semibold mb-1 text-gray-700">Color principal</label>
                  <input type="color" name="colorPrincipal" value={form.colorPrincipal} onChange={handleChange} className="w-16 h-10 p-0 border-none bg-transparent" />
                </div>
                <div>
                  <label className="block font-semibold mb-1 text-gray-700">Número de estaciones</label>
                  <input
                    type="number"
                    name="total_estaciones"
                    min={1}
                    value={form.total_estaciones}
                    onChange={handleChange}
                    className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:border-red-400 focus:ring-2 focus:ring-red-100"
                  />
                </div>
              </div>
              <div className="flex justify-end pt-4">
                <button
                  type="submit"
                  className="px-8 py-3 bg-red-600 hover:bg-red-700 text-white font-bold rounded-lg shadow text-lg transition-all"
                  disabled={guardando}
                >
                  {guardando ? 'Guardando...' : 'Guardar configuración'}
                </button>
              </div>
            </form>
          )
        ) : activeTab === 'usuarios' ? (
          <UserManagement />
        ) : activeTab === 'pacientes' ? (
          <PatientUserSupport />
        ) : (
          <div className="w-full max-w-3xl mx-auto py-12 px-4">
            <div className="bg-gray-50 border border-gray-200 rounded-xl p-6 text-gray-700 text-sm shadow-sm">
              <h2 className="font-bold text-base mb-2 text-red-700">Créditos y Aviso Legal</h2>
              <p className="mb-2">
                Esta aplicación fue desarrollada por <span className="font-semibold">Jorge Iván Anaya Herrera</span>.<br/>
                Odontos Dental Office y Ana Isabel Valadez Rabasa adquirieron una licencia de por vida, la cual <span className="font-semibold">no incluye soporte</span>.
              </p>
              <p className="text-xs text-gray-500 space-y-2">
                <span className="font-semibold">Aviso Legal y Derechos Reservados:</span><br/>
                Este software, su código fuente, diseño, documentación y cualquier material relacionado son propiedad exclusiva de Jorge Iván Anaya Herrera y están protegidos por la <span className='font-semibold'>Ley Federal del Derecho de Autor</span> (LFDA), la <span className='font-semibold'>Ley de la Propiedad Industrial</span> (LPI) y demás normatividad aplicable en los Estados Unidos Mexicanos. Todos los derechos están reservados. Queda estrictamente prohibida la reproducción total o parcial, distribución, comunicación pública, transformación, ingeniería inversa, descompilación, venta, sublicencia, arrendamiento, préstamo, o cualquier otro uso no autorizado de este software, sin el consentimiento expreso y por escrito del titular de los derechos.<br/><br/>
                El uso de este software está limitado exclusivamente a los titulares de la licencia otorgada, en este caso Odontos Dental Office y Ana Isabel Valadez Rabasa, quienes cuentan con una licencia de uso vitalicia, personal e intransferible. Esta licencia no otorga derecho a soporte técnico, actualizaciones, ni a ningún otro servicio adicional salvo pacto expreso por escrito.<br/><br/>
                El desarrollador no asume responsabilidad alguna por daños directos, indirectos, incidentales, especiales, consecuenciales o punitivos, incluyendo pero no limitado a pérdida de datos, interrupción del negocio, fallas técnicas, o cualquier otro perjuicio derivado del uso o imposibilidad de uso de este software, incluso si se ha advertido de la posibilidad de tales daños. El usuario acepta expresamente que el uso de este sistema es bajo su propio riesgo y libera de toda responsabilidad al desarrollador.<br/><br/>
                Cualquier uso no autorizado será perseguido conforme a lo dispuesto por la LFDA, la LPI y demás leyes aplicables, pudiendo dar lugar a responsabilidades civiles, administrativas y/o penales. El usuario se obliga a respetar en todo momento los derechos de autor y propiedad intelectual del desarrollador.<br/><br/>
                El uso de este sistema implica la aceptación expresa, irrevocable y sin reservas de estos términos y condiciones legales. Si usted no está de acuerdo con alguna de las disposiciones aquí establecidas, deberá abstenerse de utilizar este software.
              </p>
            </div>
          </div>
        )}
      </div>
      {notification && (
        <Notification
          message={notification.message}
          type={notification.type}
          onClose={() => setNotification(null)}
        />
      )}
    </DashboardLayout>
  );
};

export default Configuracion;
