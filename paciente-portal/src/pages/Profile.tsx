import React from 'react';

const Profile: React.FC = () => {
  return (
    <div className="min-h-screen flex items-center justify-center bg-blue-50">
      <div className="bg-white p-8 rounded shadow-md w-full max-w-md">
        <h2 className="text-2xl font-bold mb-6 text-center">Mi perfil</h2>
        <form>
          <div className="mb-4">
            <label className="block mb-2 text-sm font-medium">Nombre completo</label>
            <input type="text" className="w-full border rounded px-3 py-2" defaultValue="Paciente Demo" />
          </div>
          <div className="mb-4">
            <label className="block mb-2 text-sm font-medium">Correo electrónico</label>
            <input type="email" className="w-full border rounded px-3 py-2" defaultValue="paciente@demo.com" />
          </div>
          <button type="submit" className="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700">Guardar cambios</button>
        </form>
      </div>
    </div>
  );
};

export default Profile;
