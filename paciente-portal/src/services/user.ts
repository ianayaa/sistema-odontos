import axios from 'axios';
import { getToken } from './auth';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:3000/api';

export async function getCurrentUser() {
  const token = getToken();
  if (!token) throw new Error('No autenticado');
  const res = await axios.get(`${API_URL}/users/me`, {
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  return res.data;
}
