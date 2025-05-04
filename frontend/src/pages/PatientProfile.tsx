import React from 'react';
import { useParams, NavLink, Outlet } from 'react-router-dom';

const tabs = [
  { label: 'Datos generales', path: '' },
  { label: 'Historia clínica', path: 'historia-clinica' },
  { label: 'Citas', path: 'citas' },
  { label: 'Pagos', path: 'pagos' },
];

const PatientProfile: React.FC = () => {
  const { id } = useParams();
  // Aquí puedes cargar los datos del paciente con el id
  return (
    <div>
      <h2 className="text-2xl font-bold mb-2">Perfil del Paciente</h2>
      <div className="flex gap-4 mb-6 border-b border-gray-300">
        {tabs.map(tab => (
          <NavLink
            key={tab.path}
            to={tab.path}
            end={tab.path === ''}
            className={({ isActive }) =>
              `py-3 px-4 -mb-px border-b-2 text-sm font-semibold transition-colors duration-200 ` +
              (isActive ? 'border-red-600 text-red-700 bg-red-50' : 'border-transparent text-gray-600 hover:text-red-600')
            }
          >
            {tab.label}
          </NavLink>
        ))}
      </div>
      <Outlet />
    </div>
  );
};

export default PatientProfile;
