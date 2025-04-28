import { useState } from 'react';
import { login as loginApi, register as registerApi, setToken, logout as logoutApi } from '../services/auth';

export function useAuth() {
  const [user, setUser] = useState<any>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function login(email: string, password: string) {
    setLoading(true);
    setError(null);
    try {
      const data = await loginApi(email, password);
      setToken(data.token);
      setUser(data.user);
      setLoading(false);
      return true;
    } catch (err: any) {
      setError(err.response?.data?.error || 'Error al iniciar sesión');
      setLoading(false);
      return false;
    }
  }

  async function register(name: string, email: string, password: string) {
    setLoading(true);
    setError(null);
    try {
      await registerApi(name, email, password);
      setLoading(false);
      return true;
    } catch (err: any) {
      setError(err.response?.data?.error || 'Error al registrar');
      setLoading(false);
      return false;
    }
  }

  function logout() {
    logoutApi();
    setUser(null);
  }

  return { user, loading, error, login, register, logout };
}
