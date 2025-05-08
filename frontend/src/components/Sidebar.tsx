import React from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { 
  Calendar, 
  Users, 
  CurrencyDollar, 
  GearSix, 
  House, 
  SignOut,
  FileText,
  Package,
  ChartBar,
  ChatCircle,
  UserCircle,
  Calculator,
  FirstAid,
  CaretLeft,
  CaretRight
} from 'phosphor-react';
import { useAuth } from '../context/AuthContext';
import { User } from '../types/user';

const menu = [
  { label: 'Inicio', path: '/dashboard', icon: <House size={24} />, permission: 'inicio' },
  { label: 'Pacientes', path: '/pacientes', icon: <Users size={24} />, permission: 'pacientes' },
  { label: 'Citas', path: '/citas', icon: <Calendar size={24} />, permission: 'citas' },
  { label: 'Pagos', path: '/pagos', icon: <CurrencyDollar size={24} />, permission: 'pagos' },
  { label: 'Consentimientos', path: '/consentimientos', icon: <FileText size={24} />, permission: 'consentimientos' },
  { label: 'Servicios', path: '/servicios', icon: <FirstAid size={24} />, permission: 'servicios' },
  { label: 'Reportes', path: '/reportes', icon: <ChartBar size={24} />, permission: 'reportes' },
  { label: 'Comunicación', path: '/comunicacion', icon: <ChatCircle size={24} />, permission: 'comunicacion' },
  { label: 'Pagos Odontólogos', path: '/pagos-odontologos', icon: <Calculator size={24} />, permission: 'pagos_odontologos' },
  { label: 'Configuración', path: '/configuracion', icon: <GearSix size={24} />, permission: 'configuracion' },
];

interface SidebarProps {
  isCollapsed: boolean;
  setIsCollapsed: (v: boolean) => void;
}

const Sidebar: React.FC<SidebarProps> = ({ isCollapsed, setIsCollapsed }) => {
  const location = useLocation();
  const navigate = useNavigate();
  const { user } = useAuth();

  // Depuración de permisos
  console.log('Usuario actual:', user);
  console.log('Permisos del usuario:', user?.permissions);

  // Filtrar menú basado en permisos
  const allowedMenu = menu.filter(item => {
    if (!user) return false;
    // Si el usuario tiene el permiso específico, mostrar el ítem
    const hasPermission = (user as User).permissions?.includes(item.permission) || false;
    console.log(`Verificando permiso ${item.permission}:`, hasPermission);
    return hasPermission;
  });

  const handleLogout = () => {
    localStorage.removeItem('token');
    navigate('/login');
  };

  const toggleCollapse = () => {
    setIsCollapsed(!isCollapsed);
  };

  return (
    <>
      {/* Sidebar de escritorio */}
      <aside className={`hidden md:flex h-screen ${isCollapsed ? 'w-16' : 'w-64'} bg-red-600 text-white shadow-xl flex-col border-r border-red-700 transition-all duration-300`}>
        <div className="flex flex-col items-center pt-6 pb-2 px-4 gap-2">
          <button
            onClick={toggleCollapse}
            className="p-2 rounded-lg hover:bg-red-700 transition-colors mb-2"
          >
            {isCollapsed ? <CaretRight size={24} /> : <CaretLeft size={24} />}
          </button>
          {!isCollapsed && <span className="text-3xl font-extrabold tracking-wide text-white">ODONTOS</span>}
        </div>
        <nav className="flex-1 overflow-y-auto">
          <ul className={`space-y-2 ${isCollapsed ? 'px-0' : 'px-4'}`}>
            {allowedMenu.map(item => (
              <li key={item.path}>
                <Link
                  to={item.path}
                  className={`flex ${isCollapsed ? 'justify-center' : 'items-center gap-3'} px-0 py-3 rounded-lg transition-all duration-200 hover:bg-red-700/70 hover:text-white hover:scale-[1.03] ${location.pathname === item.path ? 'bg-red-700 font-bold text-white' : ''}`}
                  title={isCollapsed ? item.label : ''}
                >
                  <span className="flex items-center justify-center w-10 h-10">{item.icon}</span>
                  {!isCollapsed && <span>{item.label}</span>}
                </Link>
              </li>
            ))}
          </ul>
        </nav>
        <div className="flex flex-col gap-2 pb-2">
          <button
            className={`flex ${isCollapsed ? 'justify-center items-center w-12 h-12 mx-auto mb-2 bg-red-700 hover:bg-red-800' : 'items-center gap-2 px-4 py-3 mx-4 mb-2 bg-red-700 hover:bg-red-800 text-base font-semibold'} rounded-lg transition-all text-white`}
            onClick={handleLogout}
            title={isCollapsed ? 'Cerrar sesión' : ''}
          >
            <span className="flex items-center justify-center w-6 h-6"><SignOut size={22} /></span>
            {!isCollapsed && <span>Cerrar sesión</span>}
          </button>
          {!isCollapsed && (
            <div className="py-2 px-4 text-xs text-red-100 opacity-80 text-center leading-tight">
              ODONTOS <span className="font-semibold">by Ana Valades</span><br/>
              <span className="text-[11px]">Desarrollado por Ivan Anaya</span>
            </div>
          )}
        </div>
      </aside>

      {/* Sidebar móvil (drawer) */}
      <div className="md:hidden">
        <button
          className="fixed top-4 left-4 z-50 bg-red-600 text-white p-2 rounded-lg shadow-lg"
          onClick={() => setIsCollapsed(!isCollapsed)}
        >
          <svg width="28" height="28" fill="none" stroke="currentColor" strokeWidth="2.2" viewBox="0 0 24 24"><path d="M4 6h16M4 12h16M4 18h16" /></svg>
        </button>
        <div className={`fixed inset-0 z-40 bg-black/40 transition-opacity ${isCollapsed ? 'opacity-100 pointer-events-auto' : 'opacity-0 pointer-events-none'}`}
          onClick={() => setIsCollapsed(false)}
          style={{ transition: 'opacity 0.2s' }}
        />
        <aside className={`fixed top-0 left-0 h-full w-64 bg-red-600 text-white shadow-xl flex flex-col border-r border-red-700 z-50 transform ${isCollapsed ? 'translate-x-0' : '-translate-x-full'} transition-transform duration-300`}>
          <div className="flex flex-col items-center pt-6 pb-2 px-4 gap-2">
            {!isCollapsed && <span className="text-3xl font-extrabold tracking-wide text-white">ODONTOS</span>}
          </div>
          <nav className="flex-1 overflow-y-auto">
            <ul className={`space-y-2 ${isCollapsed ? 'px-0' : 'px-4'}`}>
              {allowedMenu.map(item => (
                <li key={item.path}>
                  <Link
                    to={item.path}
                    className={`flex ${isCollapsed ? 'justify-center' : 'items-center gap-3'} px-0 py-3 rounded-lg transition-all duration-200 hover:bg-red-700/70 hover:text-white hover:scale-[1.03] ${location.pathname === item.path ? 'bg-red-700 font-bold text-white' : ''}`}
                    title={isCollapsed ? item.label : ''}
                  >
                    <span className="flex items-center justify-center w-10 h-10">{item.icon}</span>
                    {!isCollapsed && <span>{item.label}</span>}
                  </Link>
                </li>
              ))}
            </ul>
          </nav>
          <div className="flex flex-col gap-2 pb-2">
            <button
              className={`flex ${isCollapsed ? 'justify-center items-center w-12 h-12 mx-auto mb-2 bg-red-700 hover:bg-red-800' : 'items-center gap-2 px-4 py-3 mx-4 mb-2 bg-red-700 hover:bg-red-800 text-base font-semibold'} rounded-lg transition-all text-white`}
              onClick={handleLogout}
              title={isCollapsed ? 'Cerrar sesión' : ''}
            >
              <span className="flex items-center justify-center w-6 h-6"><SignOut size={22} /></span>
              {!isCollapsed && <span>Cerrar sesión</span>}
            </button>
            {!isCollapsed && (
              <div className="py-2 px-4 text-xs text-red-100 opacity-80 text-center leading-tight">
                ODONTOS <span className="font-semibold">by Ana Valades</span><br/>
                <span className="text-[11px]">Desarrollado por Ivan Anaya</span>
              </div>
            )}
          </div>
        </aside>
      </div>
    </>
  );
};

export default Sidebar;
