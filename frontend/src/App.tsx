import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Patients from './pages/Patients';
import PatientProfile from './pages/PatientProfile';
import Appointments from './pages/Appointments';
import Payments from './pages/Payments';
import MedicalHistory from './pages/MedicalHistory';
import Odontogram from './pages/Odontogram';
import AddPatient from './pages/AddPatient';
import Configuracion from './pages/Configuracion';
import ConsentForms from './pages/ConsentForms';
import Servicios from './pages/Servicios';
import Reports from './pages/Reports';
import PatientCommunication from './pages/PatientCommunication';
import DentistPayments from './pages/DentistPayments';
import ConfirmAppointment from './pages/ConfirmAppointment';
import { useAuth } from './context/AuthContext';

const PrivateRoute: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { isAuthenticated, loading } = useAuth();

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary"></div>
      </div>
    );
  }

  return isAuthenticated ? <>{children}</> : <Navigate to="/login" />;
};

const App: React.FC = () => {
  return (
    <Router>
      <AuthProvider>
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
      </AuthProvider>
    </Router>
  );
};

export default App;
