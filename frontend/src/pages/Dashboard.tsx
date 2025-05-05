import React, { useEffect, useState } from 'react';
import DashboardLayout from '../components/DashboardLayout';
import {
  UserGroupIcon,
  CalendarIcon,
  CurrencyDollarIcon,
  ClockIcon,
  CalendarDaysIcon,
} from '@heroicons/react/24/outline';
import api from '../services/api';

const Dashboard: React.FC = () => {
  const [totalPatients, setTotalPatients] = useState<number | null>(null);
  const [todayAppointments, setTodayAppointments] = useState<number | null>(null);
  const [monthlyIncome, setMonthlyIncome] = useState<number | null>(null);
  const [nextAppointment, setNextAppointment] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [recentAppointments, setRecentAppointments] = useState<any[]>([]);

  useEffect(() => {
    const fetchStats = async () => {
      try {
        // Fecha actual
        const now = new Date();
        const currentYear = now.getFullYear();
        const currentMonth = now.getMonth();
        const currentDay = now.getDate();

        // Fecha de hace una semana (ajustada para incluir el día completo)
        const lastWeek = new Date(currentYear, currentMonth, currentDay - 7);
        lastWeek.setHours(0, 0, 0, 0); // Inicio del día
        now.setHours(23, 59, 59, 999); // Fin del día actual
        
        // Formatear fechas para la consulta de citas recientes
        const lastWeekStr = lastWeek.toISOString();
        const todayStr = now.toISOString();

        // Pacientes totales
        const patientsRes = await api.get('/patients');
        setTotalPatients(patientsRes.data.length);

        // Citas de hoy (usando solo la fecha sin hora)
        const todayDateOnly = new Date(now);
        todayDateOnly.setHours(0, 0, 0, 0);
        const todayDateStr = todayDateOnly.toISOString().split('T')[0];
        const appointmentsRes = await api.get(`/appointments?startDate=${todayDateStr}&endDate=${todayDateStr}`);
        setTodayAppointments(appointmentsRes.data.length);

        // Próxima cita (de las de hoy, la más cercana en el futuro)
        const nowTime = new Date();
        const nextAppt = appointmentsRes.data
          .map((appt: any) => ({ ...appt, dateObj: new Date(appt.date) }))
          .filter((appt: any) => appt.dateObj > nowTime)
          .sort((a: any, b: any) => a.dateObj.getTime() - b.dateObj.getTime())[0];
        setNextAppointment(nextAppt ? nextAppt.dateObj.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : '-');

        // Ingresos del mes
        const firstDay = `${currentYear}-${String(currentMonth + 1).padStart(2, '0')}-01`;
        const lastDay = new Date(currentYear, currentMonth + 1, 0).getDate();
        const lastDayStr = `${currentYear}-${String(currentMonth + 1).padStart(2, '0')}-${String(lastDay).padStart(2, '0')}`;
        const paymentsRes = await api.get(`/payments/summary?startDate=${firstDay}&endDate=${lastDayStr}`);
        setMonthlyIncome(paymentsRes.data.total);

        // Citas de la última semana
        const recentApptsRes = await api.get(`/appointments?startDate=${lastWeekStr}&endDate=${todayStr}`);
        setRecentAppointments(recentApptsRes.data);
      } catch (err) {
        console.error('Error al cargar datos:', err);
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
        <div className="card bg-white rounded-xl shadow-lg p-6">
          <div className="flex items-center gap-3 mb-4">
            <span className="flex items-center justify-center bg-red-100 text-red-600 rounded-full p-2 shadow-sm" style={{ height: 40, width: 40 }}>
              <CalendarDaysIcon className="h-6 w-6" />
            </span>
            <h3 className="text-xl font-bold text-gray-900">Citas Recientes</h3>
          </div>
          <div className="overflow-x-auto">
            {loading ? (
              <div className="text-center py-8">
                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-red-600 mx-auto"></div>
                <p className="mt-2 text-gray-500">Cargando citas...</p>
              </div>
            ) : (
              <table className="min-w-full divide-y divide-gray-200">
                <thead>
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Paciente
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Fecha y Hora
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
                  {recentAppointments.length === 0 ? (
                    <tr>
                      <td colSpan={4} className="px-6 py-4 text-center text-gray-500">
                        No hay citas recientes
                      </td>
                    </tr>
                  ) : (
                    recentAppointments.map((appointment) => (
                      <tr key={appointment.id} className="hover:bg-red-50 transition-all">
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="flex items-center">
                            <div className="text-sm font-medium text-gray-900">
                              {appointment.patient?.name || 'Paciente no especificado'}
                            </div>
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="text-sm text-gray-900">
                            {new Date(appointment.date).toLocaleString('es-MX', {
                              weekday: 'short',
                              year: 'numeric',
                              month: 'short',
                              day: 'numeric',
                              hour: '2-digit',
                              minute: '2-digit'
                            })}
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="text-sm text-gray-900">
                            {appointment.service?.name || 'No especificado'}
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${
                            appointment.status === 'COMPLETED' ? 'bg-green-100 text-green-800' :
                            appointment.status === 'CANCELLED' ? 'bg-red-100 text-red-800' :
                            appointment.status === 'CONFIRMED' ? 'bg-blue-100 text-blue-800' :
                            'bg-yellow-100 text-yellow-800'
                          }`}>
                            {appointment.status === 'COMPLETED' ? 'Completada' :
                             appointment.status === 'CANCELLED' ? 'Cancelada' :
                             appointment.status === 'CONFIRMED' ? 'Confirmada' :
                             'Agendada'}
                          </span>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            )}
          </div>
        </div>
      </div>
    </DashboardLayout>
  );
};

export default Dashboard;