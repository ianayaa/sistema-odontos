import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';

const Register: React.FC = () => {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const { register, loading, error } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const success = await register(name, email, password);
    if (success) {
      navigate('/login');
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-blue-50">
      <div className="bg-white p-8 rounded shadow-md w-full max-w-md">
        <h2 className="text-2xl font-bold mb-6 text-center">Registro de paciente</h2>
        <form onSubmit={handleSubmit}>
          <div className="mb-4">
            <label className="block mb-2 text-sm font-medium">Nombre completo</label>
            <input type="text" className="w-full border rounded px-3 py-2" required value={name} onChange={e => setName(e.target.value)} />
          </div>
          <div className="mb-4">
            <label className="block mb-2 text-sm font-medium">Correo electrónico</label>
            <input type="email" className="w-full border rounded px-3 py-2" required value={email} onChange={e => setEmail(e.target.value)} />
          </div>
          <div className="mb-6">
            <label className="block mb-2 text-sm font-medium">Contraseña</label>
            <input type="password" className="w-full border rounded px-3 py-2" required value={password} onChange={e => setPassword(e.target.value)} />
          </div>
          {error && <div className="mb-4 text-red-600 text-center">{error}</div>}
          <button type="submit" className="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700" disabled={loading}>
            {loading ? 'Registrando...' : 'Registrarse'}
          </button>
        </form>
      </div>
    </div>
  );
};

export default Register;
