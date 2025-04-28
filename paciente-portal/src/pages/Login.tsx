import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import { UserCircle } from 'phosphor-react';
import { EyeIcon, EyeSlashIcon, EnvelopeIcon, LockClosedIcon } from '@heroicons/react/24/outline';

const Login: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const { login, loading, error } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const success = await login(email, password);
    if (success) {
      navigate('/dashboard');
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md w-full space-y-8 bg-white p-8 rounded-2xl shadow-2xl border border-gray-100">
        <div className="text-center">
          <div className="flex justify-center mb-4">
            <div className="bg-red-100 p-3 rounded-full">
              <UserCircle size={48} weight="fill" color="#DC2626" />
            </div>
          </div>
          <h2 className="mt-2 text-center text-3xl font-extrabold text-gray-900">Portal Paciente</h2>
          <h3 className="mt-2 text-xl font-semibold text-red-600">By Ana Valadez</h3>
          <p className="mt-2 text-sm text-gray-600">Inicia sesión para acceder a tu cuenta</p>
        </div>

        <form onSubmit={handleSubmit} className="mt-8 space-y-6">
          {error && (
            <div className="bg-red-50 border-l-4 border-red-500 p-4 rounded-md animate-fade-in">
              <div className="flex">
                <div className="flex-shrink-0">
                  <svg className="h-5 w-5 text-red-500" viewBox="0 0 20 20" fill="currentColor">
                    <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
                  </svg>
                </div>
                <div className="ml-3">
                  <p className="text-sm text-red-700">{error}</p>
                </div>
              </div>
            </div>
          )}

          <div className="rounded-md shadow-sm -space-y-px">
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none z-10">
                <EnvelopeIcon className="h-5 w-5 text-red-600" />
              </div>
              <input
                id="email"
                name="email"
                type="email"
                autoComplete="email"
                required
                value={email}
                onChange={e => setEmail(e.target.value)}
                className="appearance-none rounded-t-md relative block w-full px-3 py-3 pl-10 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-red-500 focus:border-red-500 focus:z-10 sm:text-sm transition duration-150 ease-in-out autofill:bg-transparent focus:bg-white"
                placeholder="Correo electrónico"
              />
            </div>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none z-10">
                <LockClosedIcon className="h-5 w-5 text-red-600" />
              </div>
              <input
                id="password"
                name="password"
                type={showPassword ? 'text' : 'password'}
                autoComplete="current-password"
                required
                value={password}
                onChange={e => setPassword(e.target.value)}
                className="appearance-none rounded-b-md relative block w-full px-3 py-3 pl-10 pr-10 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-red-500 focus:border-red-500 focus:z-10 sm:text-sm transition duration-150 ease-in-out autofill:bg-transparent focus:bg-white"
                placeholder="Contraseña"
              />
              <button
                type="button"
                tabIndex={-1}
                className="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 focus:outline-none z-20"
                onClick={() => setShowPassword(!showPassword)}
                aria-label={showPassword ? 'Ocultar contraseña' : 'Ver contraseña'}
              >
                {showPassword ? (
                  <EyeSlashIcon className="h-5 w-5" />
                ) : (
                  <EyeIcon className="h-5 w-5" />
                )}
              </button>
            </div>
          </div>

          <div className="flex items-center justify-between">
            <div className="flex items-center">
              <input
                id="remember-me"
                name="remember-me"
                type="checkbox"
                className="h-4 w-4 text-red-600 focus:ring-red-500 border-gray-300 rounded"
              />
              <label htmlFor="remember-me" className="ml-2 block text-sm text-gray-900">
                Recordarme
              </label>
            </div>

            <button
              type="button"
              onClick={() => {}}
              className="text-sm font-medium text-red-600 hover:text-red-500 focus:outline-none focus:underline transition duration-150 ease-in-out"
            >
              ¿Olvidaste tu contraseña?
            </button>
          </div>

          <div>
            <button
              type="submit"
              className="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 transition duration-150 ease-in-out transform hover:scale-105"
              disabled={loading}
            >
              <span className="absolute left-0 inset-y-0 flex items-center pl-3">
                <LockClosedIcon className="h-5 w-5 text-red-300" />
              </span>
              {loading ? 'Entrando...' : 'Iniciar sesión'}
            </button>
          </div>
        </form>

        <div className="text-center text-xs text-gray-500 mt-8">
          Desarrollado por Ivan Anaya
        </div>
      </div>
    </div>
  );
};

export default Login;
