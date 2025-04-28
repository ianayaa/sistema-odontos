import axios from 'axios';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:3000/api';

export async function login(email: string, password: string) {
  const res = await axios.post(`${API_URL}/users/login`, { email, password });
  return res.data;
}

export async function register(name: string, email: string, password: string) {
  // Por defecto, el rol será 'PATIENT' para el portal de pacientes
  const res = await axios.post(`${API_URL}/users`, { name, email, password, role: 'PATIENT' });
  return res.data;
}

export function setToken(token: string) {
  localStorage.setItem('token', token);
}

export function getToken() {
  return localStorage.getItem('token');
}

export function logout() {
  localStorage.removeItem('token');
}
