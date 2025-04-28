import React, { useEffect, useState } from 'react';
import { getCurrentUser } from '../services/user';

const Dashboard: React.FC = () => {
  const [user, setUser] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchUser() {
      try {
        const data = await getCurrentUser();
        setUser(data);
      } catch (err: any) {
        setError('Error al cargar datos del paciente');
      } finally {
        setLoading(false);
      }
    }
    fetchUser();
  }, []);

  if (loading) return <div className="min-h-screen flex items-center justify-center">Cargando...</div>;
  if (error) return <div className="min-h-screen flex items-center justify-center text-red-600">{error}</div>;

  return (
    <div className="min-h-screen bg-blue-50 flex flex-col items-center justify-center">
      <div className="bg-white p-8 rounded shadow-md w-full max-w-2xl">
        <h1 className="text-2xl font-bold mb-4">Bienvenido, {user?.name || 'Paciente'}</h1>
        <p className="mb-2">Correo: {user?.email}</p>
        <p className="mb-2">Rol: {user?.role}</p>
        <p className="mb-2">Aquí podrás ver y gestionar tus citas, consultar tu historial y editar tu perfil.</p>
      </div>
    </div>
  );
};

export default Dashboard;
