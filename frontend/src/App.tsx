import React, { Suspense } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate, useLocation } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import { useAuth } from './context/AuthContext';

// Componentes cargados inmediatamente
import Login from './pages/Login';

// Componentes cargados bajo demanda
const Dashboard = React.lazy(() => import('./pages/Dashboard'));
const Patients = React.lazy(() => import('./pages/Patients'));
const PatientProfile = React.lazy(() => import('./pages/PatientProfile'));
const Appointments = React.lazy(() => import('./pages/Appointments'));
const Payments = React.lazy(() => import('./pages/Payments'));
const MedicalHistory = React.lazy(() => import('./pages/MedicalHistory'));
const Odontogram = React.lazy(() => import('./pages/Odontogram'));
const AddPatient = React.lazy(() => import('./pages/AddPatient'));
const Configuracion = React.lazy(() => import('./pages/Configuracion'));
const ConsentForms = React.lazy(() => import('./pages/ConsentForms'));
const Servicios = React.lazy(() => import('./pages/Servicios'));
const Reports = React.lazy(() => import('./pages/Reports'));
const PatientCommunication = React.lazy(() => import('./pages/PatientCommunication'));
const DentistPayments = React.lazy(() => import('./pages/DentistPayments'));
const ConfirmAppointment = React.lazy(() => import('./pages/ConfirmAppointment'));

// Componente de carga
const LoadingSpinner = () => (
  <div className="min-h-screen flex items-center justify-center">
    <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary"></div>
  </div>
);

const PrivateRoute: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { isAuthenticated, loading } = useAuth();

  if (loading) {
    return <LoadingSpinner />;
  }

  return isAuthenticated ? <>{children}</> : <Navigate to="/login" />;
};

const TITLES: Record<string, string> = {
  '/dashboard': 'Dashboard',
  '/pacientes': 'Pacientes',
  '/pacientes/nuevo': 'Nuevo Paciente',
  '/citas': 'Citas',
  '/pagos': 'Pagos',
  '/configuracion': 'Configuración',
  '/consentimientos': 'Consentimientos',
  '/servicios': 'Servicios',
  '/reportes': 'Reportes',
  '/comunicacion': 'Comunicación',
  '/pagos-odontologos': 'Pagos Odontólogos',
  '/login': 'Login',
};

const usePageTitle = () => {
  const location = useLocation();
  React.useEffect(() => {
    let page = TITLES[location.pathname] || '';
    // Manejo especial para rutas dinámicas
    if (location.pathname.startsWith('/pacientes/') && location.pathname !== '/pacientes/nuevo') {
      page = 'Perfil de Paciente';
    }
    if (location.pathname.startsWith('/confirmar-cita/')) {
      page = 'Confirmar Cita';
    }
    document.title = `Odontos By Ana Valades${page ? ' - ' + page : ''}`;
  }, [location.pathname]);
};

const PageTitleUpdater: React.FC = () => {
  usePageTitle();
  return null;
};

const App: React.FC = () => {
  return (
    <Router>
      <PageTitleUpdater />
      <AuthProvider>
        <Suspense fallback={<LoadingSpinner />}>
          <Routes>
            <Route path="/login" element={<Login />} />
            <Route path="/dashboard" element={<PrivateRoute><Dashboard /></PrivateRoute>} />
            <Route path="/pacientes" element={<PrivateRoute><Patients /></PrivateRoute>} />
            <Route path="/pacientes/nuevo" element={<PrivateRoute><AddPatient /></PrivateRoute>} />
            <Route path="/pacientes/:id/*" element={<PrivateRoute><PatientProfile /></PrivateRoute>}>
              <Route index element={<div>Datos generales del paciente</div>} />
              <Route path="historia-clinica/*" element={<MedicalHistory />}>
                <Route index element={<div>Resumen de historia clínica</div>} />
              </Route>
              <Route path="citas" element={<div>Citas del paciente</div>} />
              <Route path="pagos" element={<div>Pagos del paciente</div>} />
            </Route>
            <Route path="/citas" element={<PrivateRoute><Appointments /></PrivateRoute>} />
            <Route path="/pagos" element={<PrivateRoute><Payments /></PrivateRoute>} />
            <Route path="/configuracion" element={<PrivateRoute><Configuracion /></PrivateRoute>} />
            <Route path="/consentimientos" element={<PrivateRoute><ConsentForms /></PrivateRoute>} />
            <Route path="/servicios" element={<PrivateRoute><Servicios /></PrivateRoute>} />
            <Route path="/reportes" element={<PrivateRoute><Reports /></PrivateRoute>} />
            <Route path="/comunicacion" element={<PrivateRoute><PatientCommunication /></PrivateRoute>} />
            <Route path="/pagos-odontologos" element={<PrivateRoute><DentistPayments /></PrivateRoute>} />
            <Route path="/confirmar-cita/:id" element={<ConfirmAppointment />} />
            <Route path="/" element={<Navigate to="/dashboard" />} />
          </Routes>
        </Suspense>
      </AuthProvider>
    </Router>
  );
};

export default App;
