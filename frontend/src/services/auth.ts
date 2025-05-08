import api from './api';
import { User } from '../types/user';

export const login = async (email: string, password: string): Promise<{ token: string; user: User }> => {
  const response = await api.post('/users/login', { email, password });
  return response.data;
};

export const getCurrentUser = async (): Promise<User> => {
  const response = await api.get('/users/me');
  return response.data;
};

export const logout = () => {
  localStorage.removeItem('token');
}; 