import React from 'react';

const Appointment: React.FC = () => {
  return (
    <div className="min-h-screen flex items-center justify-center bg-blue-50">
      <div className="bg-white p-8 rounded shadow-md w-full max-w-md">
        <h2 className="text-2xl font-bold mb-6 text-center">Mis citas</h2>
        <div className="text-center text-gray-500">Aquí se mostrarán tus próximas citas.</div>
      </div>
    </div>
  );
};

export default Appointment;
