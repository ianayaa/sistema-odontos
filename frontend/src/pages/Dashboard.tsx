import React, { useEffect, useState } from 'react';
import DashboardLayout from '../components/DashboardLayout';
import {
  UserGroupIcon,
  CalendarIcon,
  CurrencyDollarIcon,
  ClockIcon,
} from '@heroicons/react/24/outline';
import api from '../services/api';

const Dashboard: React.FC = () => {
  const [totalPatients, setTotalPatients] = useState<number | null>(null);
  const [todayAppointments, setTodayAppointments] = useState<number | null>(null);
  const [monthlyIncome, setMonthlyIncome] = useState<number | null>(null);
  const [nextAppointment, setNextAppointment] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchStats = async () => {
      try {
        // Pacientes totales
        const patientsRes = await api.get('/patients');
        setTotalPatients(patientsRes.data.length);

        // Citas de hoy
        const today = new Date();
        const yyyy = today.getFullYear();
        const mm = String(today.getMonth() + 1).padStart(2, '0');
        const dd = String(today.getDate()).padStart(2, '0');
        const todayStr = `${yyyy}-${mm}-${dd}`;
        const appointmentsRes = await api.get(`/appointments?startDate=${todayStr}&endDate=${todayStr}`);
        setTodayAppointments(appointmentsRes.data.length);

        // Próxima cita (de las de hoy, la más cercana en el futuro)
        const now = new Date();
        const nextAppt = appointmentsRes.data
          .map((appt: any) => ({ ...appt, dateObj: new Date(appt.date) }))
          .filter((appt: any) => appt.dateObj > now)
          .sort((a: any, b: any) => a.dateObj.getTime() - b.dateObj.getTime())[0];
        setNextAppointment(nextAppt ? nextAppt.dateObj.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : '-');

        // Ingresos del mes
        const firstDay = `${yyyy}-${mm}-01`;
        const lastDay = new Date(yyyy, today.getMonth() + 1, 0).getDate();
        const lastDayStr = `${yyyy}-${mm}-${String(lastDay).padStart(2, '0')}`;
        const paymentsRes = await api.get(`/payments/summary?startDate=${firstDay}&endDate=${lastDayStr}`);
        setMonthlyIncome(paymentsRes.data.total);
      } catch (err) {
        // Handle error (optionally show notification)
      } finally {
        setLoading(false);
      }
    };
    fetchStats();
  }, []);

  const stats = [
    { name: 'Pacientes Totales', value: totalPatients !== null ? totalPatients : '...', icon: UserGroupIcon },
    { name: 'Citas Hoy', value: todayAppointments !== null ? todayAppointments : '...', icon: CalendarIcon },
    { name: 'Ingresos del Mes', value: monthlyIncome !== null ? `$${monthlyIncome.toLocaleString()}` : '...', icon: CurrencyDollarIcon },
    { name: 'Próxima Cita', value: nextAppointment !== null ? nextAppointment : '...', icon: ClockIcon },
  ];

  // Placeholder for recentAppointments, could be replaced with real data
  const recentAppointments = [];

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div>
          <h2 className="text-2xl font-bold text-gray-900">Dashboard</h2>
          <p className="mt-1 text-sm text-gray-500">
            Bienvenido al panel de control del sistema dental
          </p>
        </div>
        {/* Estadísticas */}
        <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
          {stats.map((stat) => (
            <div key={stat.name} className="card bg-white rounded-xl shadow-lg p-5 flex flex-col items-center border border-gray-100 hover:shadow-2xl transition-shadow duration-200">
              <div className="flex-shrink-0 bg-red-100 p-2 rounded-full mb-2">
                <stat.icon className="h-7 w-7 text-red-600" />
              </div>
              <div className="w-full flex flex-col items-center">
                <div className="text-base font-semibold text-gray-700 mb-1 text-center">{stat.name}</div>
                <div className="text-2xl font-bold text-gray-900 text-center">{stat.value}</div>
              </div>
            </div>
          ))}
        </div>
        {/* Resumen rápido */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="bg-gradient-to-r from-red-500 to-red-300 text-white rounded-xl p-6 shadow-lg flex flex-col justify-between">
            <div>
              <div className="text-lg font-semibold mb-1">Citas del día</div>
              <div className="text-3xl font-bold">{todayAppointments !== null ? todayAppointments : '...'}</div>
            </div>
            <div className="mt-4 text-sm opacity-80">Revisa y gestiona las citas programadas para hoy.</div>
          </div>
          <div className="bg-gradient-to-r from-gray-700 to-gray-500 text-white rounded-xl p-6 shadow-lg flex flex-col justify-between">
            <div>
              <div className="text-lg font-semibold mb-1">Ingresos del mes</div>
              <div className="text-3xl font-bold">{monthlyIncome !== null ? `$${monthlyIncome.toLocaleString()}` : '...'}</div>
            </div>
            <div className="mt-4 text-sm opacity-80">Consulta el resumen financiero mensual.</div>
          </div>
        </div>
        {/* Citas Recientes */}
        <div className="card">
          <h3 className="text-lg font-medium text-gray-900 mb-4">Citas Recientes</h3>
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead>
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Paciente
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Hora
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Tratamiento
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Estado
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {/* TODO: Map real recent appointments here */}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </DashboardLayout>
  );
};

export default Dashboard;