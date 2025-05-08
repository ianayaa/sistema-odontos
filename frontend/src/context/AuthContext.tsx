import React, { createContext, useContext, useState, useEffect } from 'react';
import api from '../services/api';
import axios from 'axios';

interface User {
  id: string;
  email: string;
  name: string;
  role: string;
}

interface AuthContextType {
  user: User | null;
  loading: boolean;
  error: string | null;
  accessToken: string | null;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
  isAuthenticated: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [accessToken, setAccessTokenState] = useState<string | null>(() => {
    // Recupera el token de localStorage al montar
    return localStorage.getItem('token');
  });

  // Setter sincroniza con localStorage
  const setAccessToken = (token: string | null) => {
    setAccessTokenState(token);
    if (token) {
      localStorage.setItem('token', token);
    } else {
      localStorage.removeItem('token');
    }
  };
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Interceptor de Axios para renovar accessToken automáticamente
  useEffect(() => {
    const interceptor = api.interceptors.response.use(
      response => response,
      async error => {
        const originalRequest = error.config;
        if (error.response?.status === 401 && !originalRequest._retry && accessToken) {
          originalRequest._retry = true;
          const newToken = await renewAccessToken();
          if (newToken) {
            originalRequest.headers['Authorization'] = `Bearer ${newToken}`;
            return api(originalRequest);
          } else {
            logout();
          }
        }
        return Promise.reject(error);
      }
    );
    return () => api.interceptors.response.eject(interceptor);
    // eslint-disable-next-line
  }, [accessToken]);

  useEffect(() => {
    // Al montar, intenta restaurar sesión con accessToken, o renovar si es inválido
    const tryRestoreSession = async () => {
      const localToken = localStorage.getItem('token');
      if (localToken) {
        try {
          await fetchUser(localToken);
          setAccessToken(localToken);
        } catch {
          // Si el token es inválido, intenta renovar
          const newToken = await renewAccessToken();
          if (newToken) {
            setAccessToken(newToken);
            await fetchUser(newToken);
          } else {
            setAccessToken(null);
            setUser(null);
            setLoading(false);
          }
        }
      } else {
        // Si no hay token, intenta renovar (por si la cookie sigue válida)
        const newToken = await renewAccessToken();
        if (newToken) {
          setAccessToken(newToken);
          await fetchUser(newToken);
        } else {
          setAccessToken(null);
          setUser(null);
          setLoading(false);
        }
      }
    };
    tryRestoreSession().catch(error => {
      if (error?.response?.status === 401 && window.location.pathname === '/login') {
        // Silenciar error esperado en login
      } else {
        console.error('Error al restaurar sesión:', error);
      }
    });
    // eslint-disable-next-line
  }, []);

  const fetchUser = async (token: string) => {
    try {
      const response = await api.get('/users/me', {
        headers: { Authorization: `Bearer ${token}` }
      });
      setUser(response.data);
      setError(null);
    } catch (err) {
      setUser(null);
      setError('Sesión expirada');
    } finally {
      setLoading(false);
    }
  };

  const login = async (email: string, password: string) => {
    try {
      setLoading(true);
      setError(null);
      const response = await api.post('/users/login', { email, password }, { withCredentials: true });
      const { accessToken, user } = response.data;
      setAccessToken(accessToken);
      setUser(user);
      localStorage.setItem('token', accessToken);
      setError(null);
    } catch (err: any) {
      setError(err.response?.data?.error || 'Error al iniciar sesión');
      setUser(null);
      localStorage.removeItem('token');
    } finally {
      setLoading(false);
    }
  };

  const renewAccessToken = async (): Promise<string | null> => {
    try {
      const response = await api.post('/token/refresh', {}, { withCredentials: true });
      if (response.data?.accessToken) {
        setAccessToken(response.data.accessToken);
        localStorage.setItem('token', response.data.accessToken);
        return response.data.accessToken;
      }
      return null;
    } catch {
      setAccessToken(null);
      setUser(null);
      localStorage.removeItem('token');
      return null;
    }
  };

  const logout = async () => {
    try {
      await api.post('/logout', {}, { withCredentials: true });
    } catch {}
    setAccessToken(null);
    setUser(null);
    setError(null);
  };

  const value = {
    user,
    loading,
    error,
    accessToken,
    login,
    logout,
    isAuthenticated: !!user
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};