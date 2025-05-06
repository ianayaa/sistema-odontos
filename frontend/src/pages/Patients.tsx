import React, { useEffect, useState } from 'react';
import DashboardLayout from '../components/DashboardLayout';
import api, { deletePatient } from '../services/api';
import { Link } from 'react-router-dom';
import AddPatient from './AddPatient';
import PatientProfileModal from './PatientProfileModal';
import { UserCircle, XCircle } from 'phosphor-react';
import ConfirmDeleteModal from '../components/ConfirmDeleteModal';

// Extiende el tipo Window para evitar errores TS
declare global {
  interface Window {
    closePatientProfileModal?: () => void;
  }
}

interface Patient {
  id: string;
  name: string;
  lastNamePaterno?: string;
  lastNameMaterno?: string;
  email?: string;
  phone: string;
  birthDate?: string;
  address?: string;
}

const Patients: React.FC = () => {
  useEffect(() => {
    api.get('/patients')
      .then(res => setPatients(res.data))
      .finally(() => setLoading(false));
  }, []);

  useEffect(() => {
    window.closePatientProfileModal = function() {
      window.dispatchEvent(new CustomEvent('closePatientProfileModal'));
    };
    const handler = () => setProfileModal(null);
    window.addEventListener('closePatientProfileModal', handler);
    return () => {
      window.removeEventListener('closePatientProfileModal', handler);
      delete window.closePatientProfileModal;
    };
  }, []);

  const [patients, setPatients] = useState<Patient[]>([]);
  const [loading, setLoading] = useState(true);
  const [showModal, setShowModal] = useState(false);
  const [profileModal, setProfileModal] = useState<string | null>(null);
  const [search, setSearch] = useState('');
  const [deleteModal, setDeleteModal] = useState<{ open: boolean, patient: Patient | null }>({ open: false, patient: null });
  const [errorMsg, setErrorMsg] = useState<string | null>(null);
  const [successMsg, setSuccessMsg] = useState<string | null>(null);
  const [confirmInput, setConfirmInput] = useState('');

  const handlePatientAdded = () => {
    setShowModal(false);
    setLoading(true);
    api.get('/patients')
      .then(res => setPatients(res.data))
      .finally(() => setLoading(false));
  };

  const handleDeletePatient = async (id: string) => {
    setDeleteModal({ open: false, patient: null });
    setLoading(true);
    setErrorMsg(null);
    setSuccessMsg(null);
    setConfirmInput('');
    try {
      await deletePatient(id);
      setPatients(patients => patients.filter(p => p.id !== id));
      setSuccessMsg('Paciente eliminado correctamente');
    } catch (error: any) {
      let msg = 'Ocurrió un error al eliminar el paciente.';
      if (error?.response?.data?.message) msg = error.response.data.message;
      setErrorMsg(msg);
    } finally {
      setLoading(false);
    }
  };

  // Función para normalizar texto (eliminar acentos y convertir a minúsculas)
  const normalizeText = (text: string) => {
    return text.toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '');
  };

  // Filter patients by search
  const filteredPatients = patients.filter(p => {
    const q = normalizeText(search);
    return (
      normalizeText(p.name).includes(q) ||
      normalizeText(p.lastNamePaterno || '').includes(q) ||
      normalizeText(p.lastNameMaterno || '').includes(q) ||
      (p.email && normalizeText(p.email).includes(q)) ||
      (p.phone && normalizeText(p.phone).includes(q))
    );
  });

  useEffect(() => {
    if (errorMsg) {
      const timer = setTimeout(() => setErrorMsg(null), 4000);
      return () => clearTimeout(timer);
    }
  }, [errorMsg]);

  useEffect(() => {
    if (successMsg) {
      const timer = setTimeout(() => setSuccessMsg(null), 3000);
      return () => clearTimeout(timer);
    }
  }, [successMsg]);

  return (
    <DashboardLayout>
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
        <div className="flex items-center gap-4 flex-1 mb-2 sm:mb-0">
          <div className="bg-red-100 text-red-600 rounded-full p-3">
            <UserCircle size={38} weight="duotone" />
          </div>
          <div>
            <h2 className="text-2xl font-bold text-gray-800 mb-1">Pacientes</h2>
            <p className="text-gray-500 text-base font-medium">Gestión de pacientes registrados en la clínica.</p>
          </div>
        </div>
        <div className="flex items-center gap-2 w-full sm:w-auto">
          <div className="relative w-full max-w-xs">
            <input
              type="text"
              placeholder="Buscar por nombre, correo o teléfono..."
              className="w-full pl-12 pr-4 py-2 rounded-xl border-2 border-gray-200 focus:border-red-400 focus:ring-2 focus:ring-red-100 text-gray-700 bg-white shadow transition-all placeholder-gray-400"
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
          <button
            className="bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-lg transition-all duration-200 shadow-md ml-2 whitespace-nowrap text-base"
            style={{ minHeight: '40px', minWidth: 'auto', fontSize: '1rem', paddingTop: '0.5rem', paddingBottom: '0.5rem', paddingLeft: '1rem', paddingRight: '1rem' }}
            onClick={() => setShowModal(true)}
          >
            + Nuevo Paciente
          </button>
        </div>
      </div>
      {loading ? (
        <div className="bg-white rounded-2xl shadow-xl p-8 text-center text-gray-400">
          <UserCircle size={64} weight="duotone" className="mx-auto mb-2" />
          <div className="text-lg font-semibold mb-2">Cargando pacientes...</div>
        </div>
      ) : filteredPatients.length === 0 ? (
        <div className="bg-white rounded-2xl shadow-xl p-8 text-center text-gray-400">
          <UserCircle size={64} weight="duotone" className="mx-auto mb-2" />
          <div className="text-lg font-semibold mb-2">No se encontraron pacientes</div>
          <div className="mb-4">Prueba ajustando tu búsqueda o agrega un nuevo paciente.</div>
        </div>
      ) : (
        <div className="bg-white rounded-2xl shadow-xl overflow-x-auto border border-gray-200">
          {errorMsg && (
            <div className="fixed bottom-6 right-6 z-50 animate-fadeInUp">
              <div className="flex items-center gap-2 bg-red-600 text-white px-4 py-2 rounded-lg shadow-lg min-w-[220px] max-w-xs">
                <XCircle size={20} className="text-white flex-shrink-0" />
                <span className="flex-1 text-sm font-medium">{errorMsg}</span>
                <button onClick={() => setErrorMsg(null)} className="ml-2 text-white/70 hover:text-white text-lg font-bold focus:outline-none">×</button>
              </div>
            </div>
          )}
          {successMsg && (
            <div className="fixed bottom-6 right-6 z-50 animate-fadeInUp">
              <div className="flex items-center gap-2 bg-green-600 text-white px-4 py-2 rounded-lg shadow-lg min-w-[220px] max-w-xs">
                <svg width="20" height="20" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path d="M5 13l4 4L19 7" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/></svg>
                <span className="flex-1 text-sm font-medium">{successMsg}</span>
                <button onClick={() => setSuccessMsg(null)} className="ml-2 text-white/70 hover:text-white text-lg font-bold focus:outline-none">×</button>
              </div>
            </div>
          )}
          <table className="min-w-full divide-y divide-gray-100">
            <thead className="bg-gray-50 sticky top-0 z-10">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Nombre</th>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Teléfono</th>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Correo</th>
                <th className="px-6 py-3 text-center text-xs font-semibold text-gray-500 uppercase">Acciones</th>
              </tr>
            </thead>
            <tbody>
              {filteredPatients.map(p => (
                <tr key={p.id} className="hover:bg-red-50 transition-all border-b border-gray-100 last:border-0 group">
                  <td className="px-6 py-4 flex items-center gap-3 font-medium text-gray-900">
                    <div className="bg-red-100 rounded-full h-10 w-10 flex items-center justify-center text-red-600 font-bold text-lg shadow-sm">
                      {p.name ? `${p.name.charAt(0)}${p.lastNamePaterno?.charAt(0) || ''}`.toUpperCase() : <UserCircle size={32} weight="duotone" />}
                    </div>
                    <span>{p.name} {p.lastNamePaterno} {p.lastNameMaterno}</span>
                  </td>
                  <td className="px-6 py-4">{p.phone}</td>
                  <td className="px-6 py-4">{p.email || '-'}</td>
                  <td className="px-6 py-4 text-center">
                    <button
                      onClick={() => setProfileModal(p.id)}
                      className="inline-flex items-center gap-1 text-red-600 hover:text-white hover:bg-red-600 border border-red-200 font-semibold px-3 py-1.5 rounded-lg transition-all duration-150 focus:outline-none focus:ring-2 focus:ring-red-300"
                    >
                      <svg width="20" height="20" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7" /><line x1="21" y1="21" x2="16.65" y2="16.65" /></svg>
                      Ver perfil
                    </button>
                    <button
                      onClick={() => setDeleteModal({ open: true, patient: p })}
                      className="inline-flex items-center gap-1 text-gray-400 hover:text-white hover:bg-red-400 border border-gray-200 font-semibold px-3 py-1.5 rounded-lg transition-all duration-150 focus:outline-none focus:ring-2 focus:ring-red-200 ml-2"
                      title="Eliminar paciente"
                      aria-label="Eliminar paciente"
                    >
                      <svg width="20" height="20" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path d="M3 6h18M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2m2 0v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6h14z"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/></svg>
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
      {showModal && <AddPatient onSuccess={handlePatientAdded} />}
      {profileModal && (
        <PatientProfileModal patientId={profileModal} />
      )}
      {deleteModal.open && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40">
          <div className="bg-white rounded-2xl shadow-2xl p-8 max-w-xs w-full flex flex-col items-center">
            <XCircle size={48} className="text-red-500 mb-2" />
            <h2 className="text-lg font-bold text-red-700 mb-2 text-center">¿Seguro que deseas eliminar este paciente?</h2>
            <p className="text-gray-600 text-sm mb-4 text-center">Esta acción es permanente. Escribe <b>ELIMINAR</b> para confirmar.</p>
            <input
              type="text"
              className="border border-gray-300 rounded-lg px-3 py-2 mb-4 w-full text-center focus:ring-2 focus:ring-red-200"
              placeholder="Escribe ELIMINAR"
              value={confirmInput}
              onChange={e => setConfirmInput(e.target.value)}
              autoFocus
            />
            <div className="flex gap-2 w-full">
              <button
                onClick={() => { setDeleteModal({ open: false, patient: null }); setConfirmInput(''); }}
                className="flex-1 bg-gray-100 hover:bg-gray-200 text-gray-700 font-semibold py-2 rounded-lg transition-colors"
              >Cancelar</button>
              <button
                onClick={() => confirmInput === 'ELIMINAR' && deleteModal.patient && handleDeletePatient(deleteModal.patient.id)}
                className={`flex-1 bg-red-600 hover:bg-red-700 text-white font-semibold py-2 rounded-lg transition-colors ${confirmInput !== 'ELIMINAR' ? 'opacity-50 cursor-not-allowed' : ''}`}
                disabled={confirmInput !== 'ELIMINAR'}
              >Eliminar</button>
            </div>
          </div>
        </div>
      )}
    </DashboardLayout>
  );
};

export default Patients;
