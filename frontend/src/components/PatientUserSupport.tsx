import React, { useEffect, useState } from 'react';
import api from '../services/api';
import { UserCircle } from 'phosphor-react';

interface PatientUser {
  id: string;
  name: string;
  email: string;
  isActive: boolean;
}

const PatientUserSupport: React.FC = () => {
  const [users, setUsers] = useState<PatientUser[]>([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    loadUsers();
  }, []);

  const loadUsers = async () => {
    setLoading(true);
    try {
      const res = await api.get('/users');
      // Filtrar solo usuarios paciente
      setUsers(res.data.filter((u: any) => u.role === 'PATIENT'));
    } catch (err) {
      setError('Error al cargar usuarios');
    } finally {
      setLoading(false);
    }
  };

  const filteredUsers = users.filter(u =>
    u.name.toLowerCase().includes(search.toLowerCase()) ||
    u.email.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-4 mb-2">
        <div className="bg-red-100 text-red-600 rounded-full p-3">
          <UserCircle size={24} weight="duotone" />
        </div>
        <div>
          <h2 className="text-xl font-bold text-gray-800">Soporte a Usuario Paciente</h2>
          <p className="text-gray-500">Busca y da soporte a los usuarios pacientes registrados.</p>
        </div>
      </div>
      <div className="bg-white rounded-xl shadow-xl p-6 border border-gray-100">
        <div className="mb-6">
          <input
            type="text"
            placeholder="Buscar por nombre o correo..."
            className="w-full max-w-md px-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-red-100 focus:border-red-400 text-gray-700 bg-white shadow transition-all placeholder-gray-400"
            value={search}
            onChange={e => setSearch(e.target.value)}
          />
        </div>
        {loading ? (
          <div className="text-gray-400 text-center py-8">Cargando usuarios...</div>
        ) : error ? (
          <div className="text-red-500 text-center py-8">{error}</div>
        ) : filteredUsers.length === 0 ? (
          <div className="text-gray-400 text-center py-8">No se encontraron usuarios paciente</div>
        ) : (
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-100">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Nombre</th>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Email</th>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Estado</th>
                  <th className="px-6 py-3 text-center text-xs font-semibold text-gray-500 uppercase">Acciones</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-100">
                {filteredUsers.map(user => (
                  <tr key={user.id} className="hover:bg-red-50 transition-all border-b border-gray-100 last:border-0 group">
                    <td className="px-6 py-4 flex items-center gap-3 font-medium text-gray-900">
                      <div className="bg-red-100 rounded-full h-10 w-10 flex items-center justify-center text-red-600 font-bold text-lg shadow-sm">
                        {user.name ? user.name.charAt(0).toUpperCase() : <UserCircle size={24} weight="duotone" />}
                      </div>
                      <span>{user.name}</span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">{user.email}</td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className={`px-2 py-1 rounded-full text-xs font-semibold ${user.isActive ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>
                        {user.isActive ? 'Activo' : 'Inactivo'}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-center">
                      <button className="bg-blue-100 text-blue-700 hover:bg-blue-200 font-semibold px-3 py-1 rounded-lg text-xs transition-all shadow-sm">Resetear contraseña</button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
};

export default PatientUserSupport; 