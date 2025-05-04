import React, { useEffect, useState } from 'react';
import api from '../services/api';
import MedicalHistoryForm from '../components/MedicalHistoryForm';
import Odontogram from '../components/Odontogram';
import { X } from 'phosphor-react';

interface PatientProfileModalProps {
  patientId: string;
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

const PatientProfileModal: React.FC<PatientProfileModalProps> = ({ patientId }) => {
  const [patient, setPatient] = useState<Patient | null>(null);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<'info' | 'historia' | 'citas' | 'pagos' | 'odontograma'>('info');
  const [editMode, setEditMode] = useState(false);
  const [editForm, setEditForm] = useState({
    name: '',
    lastNamePaterno: '',
    lastNameMaterno: '',
    email: '',
    phone: '',
    birthDate: '',
    address: ''
  });
  const [odontogram, setOdontogram] = useState<any>(null);
  const [loadingOdontogram, setLoadingOdontogram] = useState(false);
  const [appointments, setAppointments] = useState<any[]>([]);
  const [loadingAppointments, setLoadingAppointments] = useState(false);
  const [payments, setPayments] = useState<any[]>([]);
  const [loadingPayments, setLoadingPayments] = useState(false);

  useEffect(() => {
    setLoading(true);
    api.get(`/patients/${patientId}`)
      .then(res => {
        setPatient(res.data);
        setEditForm({
          name: res.data.name || '',
          lastNamePaterno: res.data.lastNamePaterno || '',
          lastNameMaterno: res.data.lastNameMaterno || '',
          email: res.data.email || '',
          phone: res.data.phone || '',
          birthDate: res.data.birthDate || '',
          address: res.data.address || ''
        });
      })
      .finally(() => setLoading(false));
  }, [patientId]);

  useEffect(() => {
    if (activeTab === 'odontograma') {
      setLoadingOdontogram(true);
      api.get(`/odontogram/patient/${patientId}`)
        .then(res => {
          setOdontogram(res.data?.data || null);
        })
        .catch(() => setOdontogram(null))
        .finally(() => setLoadingOdontogram(false));
    }
  }, [activeTab, patientId]);

  useEffect(() => {
    if (activeTab === 'citas') {
      setLoadingAppointments(true);
      api.get(`/appointments/patient/${patientId}`)
        .then(res => setAppointments(res.data))
        .finally(() => setLoadingAppointments(false));
    }
    if (activeTab === 'pagos') {
      setLoadingPayments(true);
      api.get('/payments', { params: { patientId } })
        .then(res => setPayments(res.data))
        .finally(() => setLoadingPayments(false));
    }
  }, [activeTab, patientId]);

  const handleEditChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setEditForm({ ...editForm, [e.target.name]: e.target.value });
  };

  const handleEditSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      await api.put(`/patients/${patientId}`, {
        ...editForm
      });
      setPatient({ ...patient!, ...editForm });
      setEditMode(false);
    } catch (err) {
      // Manejar error
    } finally {
      setLoading(false);
    }
  };

  const handleOdontogramChange = async (data: any) => {
    setOdontogram(data);
    try {
      await api.put(`/odontogram/patient/${patientId}`, { data });
    } catch (err) {
      // Manejar error si es necesario
    }
  };

  if (loading) {
    return (
      <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-30">
        <div className="bg-white w-full max-w-7xl mx-4 md:mx-0 rounded-2xl shadow-2xl p-0 md:p-10 overflow-y-auto max-h-[95vh] relative">
          <div className="text-gray-500 text-center py-8">Cargando perfil...</div>
        </div>
      </div>
    );
  }
  if (!patient) {
    return (
      <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-30">
        <div className="bg-white w-full max-w-7xl mx-4 md:mx-0 rounded-2xl shadow-2xl p-0 md:p-10 overflow-y-auto max-h-[95vh] relative">
          <div className="text-red-600 text-center py-8">No se encontró el paciente.</div>
        </div>
      </div>
    );
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-30">
      <div className="bg-white w-full max-w-7xl mx-4 md:mx-0 rounded-2xl shadow-2xl p-0 md:p-10 overflow-y-auto max-h-[95vh] relative">
        <button
          className="absolute top-4 right-4 text-gray-400 hover:text-red-600 text-2xl font-bold z-10 p-1 rounded-full transition-colors focus:outline-none"
          onClick={() => {
            if (typeof window !== 'undefined' && (window as any).closePatientProfileModal) {
              (window as any).closePatientProfileModal();
            }
          }}
          aria-label="Cerrar"
          type="button"
        >
          <X size={28} className="text-red-400 hover:text-red-600" />
        </button>
        <div className="space-y-6">
          <div className="flex items-center gap-4 mb-4">
            <div className="rounded-full bg-red-100 text-red-600 w-16 h-16 flex items-center justify-center text-3xl font-bold">
              {patient.name?.charAt(0)}{patient.lastNamePaterno?.charAt(0)}
            </div>
            <div>
              <div className="text-xl font-bold text-gray-900">{patient.name} {patient.lastNamePaterno} {patient.lastNameMaterno}</div>
              <div className="text-sm text-gray-500">ID: {patient.id}</div>
            </div>
          </div>
          {/* Tabs */}
          <div className="flex gap-2 border-b border-gray-200 mb-4">
            <button
              className={`py-2 px-4 text-sm font-semibold border-b-2 transition-colors duration-200 ${activeTab === 'info' ? 'border-red-600 text-red-700 bg-red-50' : 'border-transparent text-gray-600 hover:text-red-600'}`}
              onClick={() => setActiveTab('info')}
            >
              Datos generales
            </button>
            <button
              className={`py-2 px-4 text-sm font-semibold border-b-2 transition-colors duration-200 ${activeTab === 'historia' ? 'border-red-600 text-red-700 bg-red-50' : 'border-transparent text-gray-600 hover:text-red-600'}`}
              onClick={() => setActiveTab('historia')}
            >
              Historia clínica
            </button>
            <button
              className={`py-2 px-4 text-sm font-semibold border-b-2 transition-colors duration-200 ${activeTab === 'citas' ? 'border-red-600 text-red-700 bg-red-50' : 'border-transparent text-gray-600 hover:text-red-600'}`}
              onClick={() => setActiveTab('citas')}
            >
              Citas
            </button>
            <button
              className={`py-2 px-4 text-sm font-semibold border-b-2 transition-colors duration-200 ${activeTab === 'pagos' ? 'border-red-600 text-red-700 bg-red-50' : 'border-transparent text-gray-600 hover:text-red-600'}`}
              onClick={() => setActiveTab('pagos')}
            >
              Pagos
            </button>
            <button
              className={`py-2 px-4 text-sm font-semibold border-b-2 transition-colors duration-200 ${activeTab === 'odontograma' ? 'border-red-600 text-red-700 bg-red-50' : 'border-transparent text-gray-600 hover:text-red-600'}`}
              onClick={() => setActiveTab('odontograma')}
            >
              Odontograma
            </button>
          </div>
          {/* Tab content */}
          {activeTab === 'info' && (
            <div>
              {editMode ? (
                <form onSubmit={handleEditSubmit} className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <div className="text-xs text-gray-400">Nombre(s)</div>
                    <input
                      type="text"
                      name="name"
                      value={editForm.name}
                      onChange={handleEditChange}
                      className="input-field"
                      required
                    />
                  </div>
                  <div>
                    <div className="text-xs text-gray-400">Apellido paterno</div>
                    <input
                      type="text"
                      name="lastNamePaterno"
                      value={editForm.lastNamePaterno}
                      onChange={handleEditChange}
                      className="input-field"
                      required
                    />
                  </div>
                  <div>
                    <div className="text-xs text-gray-400">Apellido materno</div>
                    <input
                      type="text"
                      name="lastNameMaterno"
                      value={editForm.lastNameMaterno}
                      onChange={handleEditChange}
                      className="input-field"
                      required
                    />
                  </div>
                  <div>
                    <div className="text-xs text-gray-400">Correo electrónico</div>
                    <input
                      type="email"
                      name="email"
                      value={editForm.email}
                      onChange={handleEditChange}
                      className="input-field"
                    />
                  </div>
                  <div>
                    <div className="text-xs text-gray-400">Teléfono</div>
                    <input
                      type="text"
                      name="phone"
                      value={editForm.phone}
                      onChange={handleEditChange}
                      className="input-field"
                    />
                  </div>
                  <div>
                    <div className="text-xs text-gray-400">Fecha de nacimiento</div>
                    <input
                      type="date"
                      name="birthDate"
                      value={editForm.birthDate ? editForm.birthDate.substring(0, 10) : ''}
                      onChange={handleEditChange}
                      className="input-field"
                    />
                  </div>
                  <div>
                    <div className="text-xs text-gray-400">Dirección</div>
                    <input
                      type="text"
                      name="address"
                      value={editForm.address}
                      onChange={handleEditChange}
                      className="input-field"
                    />
                  </div>
                  <div className="col-span-2 flex gap-2 mt-4 justify-end">
                    <button
                      type="button"
                      className="btn-secondary"
                      onClick={() => setEditMode(false)}
                    >
                      Cancelar
                    </button>
                    <button
                      type="submit"
                      className="btn-primary"
                      disabled={loading}
                    >
                      Guardar
                    </button>
                  </div>
                </form>
              ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <div className="text-xs text-gray-400">Nombre completo</div>
                    <div className="text-base text-gray-800">{patient.name} {patient.lastNamePaterno} {patient.lastNameMaterno}</div>
                  </div>
                  <div>
                    <div className="text-xs text-gray-400">Correo electrónico</div>
                    <div className="text-base text-gray-800">{patient.email || '-'}</div>
                  </div>
                  <div>
                    <div className="text-xs text-gray-400">Teléfono</div>
                    <div className="text-base text-gray-800">{patient.phone}</div>
                  </div>
                  <div>
                    <div className="text-xs text-gray-400">Fecha de nacimiento</div>
                    <div className="text-base text-gray-800">{patient.birthDate ? patient.birthDate.split('T')[0].split('-').reverse().join('/') : '-'}</div>
                  </div>
                  <div className="md:col-span-2">
                    <div className="text-xs text-gray-400">Dirección</div>
                    <div className="text-base text-gray-800">{patient.address || '-'}</div>
                  </div>
                  <div className="col-span-2 flex justify-end mt-2">
                    <button
                      className="btn-primary"
                      onClick={() => setEditMode(true)}
                    >
                      Editar
                    </button>
                  </div>
                </div>
              )}
            </div>
          )}
          {activeTab === 'historia' && (
            <MedicalHistoryForm patientId={patient.id} />
          )}
          {activeTab === 'odontograma' && (
            <div>
              {loadingOdontogram ? (
                <div className="text-gray-500 text-center py-8">Cargando odontograma...</div>
              ) : (
                <Odontogram value={odontogram} onChange={handleOdontogramChange} />
              )}
            </div>
          )}
          {activeTab === 'citas' && (
            <div className="py-4">
              {loadingAppointments ? (
                <div className="text-gray-500 text-center py-8">Cargando citas...</div>
              ) : appointments.length === 0 ? (
                <div className="text-gray-500 text-center py-8">No hay citas registradas.</div>
              ) : (
                <div className="overflow-x-auto">
                  <table className="min-w-full divide-y divide-gray-100">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-4 py-2 text-left text-xs font-semibold text-gray-500 uppercase">Fecha</th>
                        <th className="px-4 py-2 text-left text-xs font-semibold text-gray-500 uppercase">Estado</th>
                        <th className="px-4 py-2 text-left text-xs font-semibold text-gray-500 uppercase">Notas</th>
                      </tr>
                    </thead>
                    <tbody>
                      {appointments.map((appt) => (
                        <tr key={appt.id} className="border-b last:border-0 hover:bg-red-50">
                          <td className="px-4 py-2">{new Date(appt.date).toLocaleString('es-MX')}</td>
                          <td className="px-4 py-2">{appt.status}</td>
                          <td className="px-4 py-2">{appt.notes || '-'}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </div>
          )}
          {activeTab === 'pagos' && (
            <div className="py-4">
              {loadingPayments ? (
                <div className="text-gray-500 text-center py-8">Cargando pagos...</div>
              ) : payments.length === 0 ? (
                <div className="text-gray-500 text-center py-8">No hay pagos registrados.</div>
              ) : (
                <div className="overflow-x-auto">
                  <table className="min-w-full divide-y divide-gray-100">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-4 py-2 text-left text-xs font-semibold text-gray-500 uppercase">Referencia</th>
                        <th className="px-4 py-2 text-left text-xs font-semibold text-gray-500 uppercase">Fecha</th>
                        <th className="px-4 py-2 text-left text-xs font-semibold text-gray-500 uppercase">Método</th>
                        <th className="px-4 py-2 text-left text-xs font-semibold text-gray-500 uppercase">Monto</th>
                        <th className="px-4 py-2 text-left text-xs font-semibold text-gray-500 uppercase">Estado</th>
                      </tr>
                    </thead>
                    <tbody>
                      {payments.map((pago) => (
                        <tr key={pago.id} className="border-b last:border-0 hover:bg-red-50">
                          <td className="px-4 py-2">{pago.reference || '-'}</td>
                          <td className="px-4 py-2">{pago.date ? new Date(pago.date).toLocaleDateString('es-MX') : '-'}</td>
                          <td className="px-4 py-2">{pago.method === 'credit_card' ? 'Tarjeta' : pago.method === 'transfer' ? 'Transferencia' : pago.method === 'cash' ? 'Efectivo' : pago.method}</td>
                          <td className="px-4 py-2">${pago.amount?.toLocaleString('es-MX')}</td>
                          <td className="px-4 py-2">{pago.status === 'completed' ? 'Completado' : pago.status === 'pending' ? 'Pendiente' : pago.status === 'failed' ? 'Fallido' : pago.status === 'refunded' ? 'Reembolsado' : pago.status}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default PatientProfileModal;
