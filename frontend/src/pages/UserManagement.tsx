import React, { useState, useEffect } from 'react';
import { User, UserPlus, Pencil, Trash, Eye, EyeSlash } from 'phosphor-react';
import api from '../services/api';
import CreateUserModal from '../components/CreateUserModal';
import EditUserModal from '../components/EditUserModal';

interface UserData {
  id: string;
  name: string;
  lastNamePaterno?: string;
  lastNameMaterno?: string;
  email: string;
  role: 'ADMIN' | 'DENTIST' | 'ASSISTANT' | 'PATIENT';
  status: 'active' | 'inactive';
}

interface UserForm {
  name: string;
  email: string;
  password: string;
  role: 'ADMIN' | 'DENTIST' | 'ASSISTANT' | 'PATIENT';
}

const UserManagement: React.FC = () => {
  const [users, setUsers] = useState<UserData[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [editUser, setEditUser] = useState<UserData | null>(null);
  const [showDelete, setShowDelete] = useState<{id: string, name: string} | null>(null);

  // Criterios mínimos: 8 caracteres, una mayúscula, una minúscula, un número, un símbolo
  const passwordCriteria = [
    { label: 'Al menos 8 caracteres', test: (pw: string) => pw.length >= 8 },
    { label: 'Una letra mayúscula', test: (pw: string) => /[A-Z]/.test(pw) },
    { label: 'Una letra minúscula', test: (pw: string) => /[a-z]/.test(pw) },
    { label: 'Un número', test: (pw: string) => /[0-9]/.test(pw) },
    { label: 'Un símbolo', test: (pw: string) => /[^A-Za-z0-9]/.test(pw) },
  ];

  useEffect(() => {
    loadUsers();
  }, []);

  const loadUsers = async () => {
    try {
      const response = await api.get('/users');
      setUsers(response.data);
    } catch (error) {
      console.error('Error al cargar usuarios:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleOpenCreate = () => {
    setShowCreateModal(true);
  };

  const handleOpenEdit = (user: UserData) => {
    setEditUser(user);
    setShowEditModal(true);
  };

  const handleCloseCreate = () => {
    setShowCreateModal(false);
  };

  const handleCloseEdit = () => {
    setShowEditModal(false);
    setEditUser(null);
  };

  const handleCreateUser = async (data: { name: string; lastNamePaterno: string; lastNameMaterno: string; email: string; password: string; role: string }) => {
    await api.post('/users', data);
    setShowCreateModal(false);
    loadUsers();
  };

  const handleEditUser = async (data: { id: string; name: string; lastNamePaterno: string; lastNameMaterno: string; email: string; role: string }) => {
    await api.put(`/users/${data.id}`, data);
    setShowEditModal(false);
    setEditUser(null);
    loadUsers();
  };

  const handleDelete = async (id: string) => {
    const user = users.find(u => u.id === id);
    setShowDelete(user ? { id, name: user.name } : null);
  };

  const confirmDelete = async () => {
    if (!showDelete) return;
    try {
      await api.delete(`/users/${showDelete.id}`);
      setShowDelete(null);
      loadUsers();
    } catch (error) {
      alert('Error al eliminar usuario');
    }
  };

  // Filtrar usuarios: solo mostrar ADMIN, DENTIST y ASSISTANT
  const filteredUsers = users
    .filter(user => user.role !== 'PATIENT')
    .filter(user => 
      user.name.toLowerCase().includes(search.toLowerCase()) ||
      user.email.toLowerCase().includes(search.toLowerCase())
    );

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
          <div className="bg-red-100 text-red-600 rounded-full p-3">
            <User size={24} weight="duotone" />
          </div>
          <div>
            <h2 className="text-xl font-bold text-gray-800">Gestión de Usuarios</h2>
            <p className="text-gray-500">Administra los usuarios del sistema</p>
          </div>
        </div>
        <button
          className="flex items-center gap-2 bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-lg mb-4 transition-colors"
          onClick={handleOpenCreate}
        >
          <UserPlus size={20} /> Nuevo Usuario
        </button>
      </div>

      <div className="bg-white rounded-xl shadow-xl p-6">
        <div className="mb-6">
          <input
            type="text"
            placeholder="Buscar usuarios..."
            className="w-full max-w-md px-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-red-100 focus:border-red-400"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>

        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nombre</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Rol</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Estado</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {filteredUsers.map((user) => (
                <tr key={user.id} className="hover:bg-gray-50">
                  <td className="px-6 py-4 whitespace-nowrap">{user.name} {user.lastNamePaterno || ''} {user.lastNameMaterno || ''}</td>
                  <td className="px-6 py-4 whitespace-nowrap">{user.email}</td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <span className={`px-2 py-1 rounded-full text-xs font-semibold ${
                      user.role === 'ADMIN' ? 'bg-purple-100 text-purple-800' :
                      user.role === 'DENTIST' ? 'bg-blue-100 text-blue-800' :
                      user.role === 'ASSISTANT' ? 'bg-green-100 text-green-800' :
                      'bg-gray-100 text-gray-800'
                    }`}>
                      {user.role}
                    </span>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <span className={`px-2 py-1 rounded-full text-xs font-semibold ${
                      user.status === 'active' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
                    }`}>
                      {user.status === 'active' ? 'Activo' : 'Inactivo'}
                    </span>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="flex items-center gap-2">
                      <Pencil
                        className="cursor-pointer text-blue-600 hover:text-blue-800"
                        size={20}
                        onClick={() => handleOpenEdit(user)}
                      />
                      {user.role !== 'ADMIN' && (
                        <button 
                          className="text-red-600 hover:text-red-800"
                          onClick={() => handleDelete(user.id)}
                        >
                          <Trash size={20} />
                        </button>
                      )}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Modal para crear usuario */}
      <CreateUserModal
        open={showCreateModal}
        onClose={handleCloseCreate}
        onCreate={handleCreateUser}
      />
      {/* Modal para editar usuario */}
      <EditUserModal
        open={showEditModal}
        onClose={handleCloseEdit}
        user={editUser}
        onEdit={handleEditUser}
      />
      {/* Modal de confirmación de eliminación */}
      {showDelete && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-40">
          <div className="bg-white rounded-xl shadow-2xl p-8 max-w-sm w-full text-center">
            <h3 className="text-lg font-bold mb-4 text-red-700">¿Eliminar usuario?</h3>
            <p className="mb-4">¿Estás seguro de que deseas eliminar a <span className="font-semibold">{showDelete.name}</span>? Esta acción no se puede deshacer.</p>
            <div className="flex justify-center gap-4">
              <button className="px-4 py-2 rounded bg-gray-200 hover:bg-gray-300 text-gray-700 font-semibold" onClick={() => setShowDelete(null)}>
                Cancelar
              </button>
              <button className="px-4 py-2 rounded bg-red-600 hover:bg-red-700 text-white font-semibold" onClick={e => {e.preventDefault(); confirmDelete();}}>
                Sí, eliminar
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default UserManagement; 