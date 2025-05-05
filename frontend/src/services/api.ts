import axios from 'axios';

const api = axios.create({
  baseURL: process.env.REACT_APP_API_URL || '/api',
});

api.interceptors.request.use(config => {
  const token = localStorage.getItem('token');
  if (token && config.headers) {
    config.headers['Authorization'] = `Bearer ${token}`;
  }
  return config;
});

export default api;

export const getDentistSchedule = async () => {
  const res = await api.get('/appointments/schedule');
  return res.data;
};

export const saveDentistSchedule = async (data: any) => {
  try {
    console.log('Guardando horario:', data);
  const res = await api.post('/appointments/schedule', data);
    console.log('Horario guardado exitosamente:', res.data);
  return res.data;
  } catch (error) {
    console.error('Error al guardar horario:', error);
    throw error;
  }
};

export const deletePatient = async (id: string) => {
  return api.delete(`/patients/${id}`);
};

export const getClinicConfig = async () => {
  const res = await api.get('/config');
  return res.data;
};

export const updateClinicConfig = async (data: any) => {
  const res = await api.put('/config', data);
  return res.data;
};

export const getPatients = async () => {
  const res = await api.get('/patients');
  return res.data;
};

export const getPatientAppointments = async (patientId: string) => {
  const res = await api.get(`/appointments/patient/${patientId}`);
  return res.data;
};

export const getPaymentSummary = async (params?: any) => {
  const res = await api.get('/payments/summary', { params });
  return res.data;
};

export const getServices = async () => {
  const res = await api.get('/services');
  return res.data;
};

export const getPatientsWithActiveAppointments = async () => {
  const res = await api.get('/patients/with-active-appointments');
  return res.data;
};
