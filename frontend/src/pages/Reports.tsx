import React, { useState, useEffect } from 'react';
import DashboardLayout from '../components/DashboardLayout';
import { ChartBar, CurrencyDollar, User } from 'phosphor-react';
import api from '../services/api';
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, PieChart, Pie, Cell
} from 'recharts';
import ModernDatePicker from '../components/ModernDatePicker';
import Papa from 'papaparse';
import jsPDF from 'jspdf';
import html2canvas from 'html2canvas';
import autoTable from 'jspdf-autotable';
import { Dropdown, Menu, Button, Modal, Checkbox, Select } from 'antd';
import { DownOutlined, ExportOutlined } from '@ant-design/icons';

const Reports: React.FC = () => {
  const [reportType, setReportType] = useState('appointments');
  const [dateRange, setDateRange] = useState<[Date, Date] | null>(null);
  const [appointments, setAppointments] = useState<any[]>([]);
  const [incomeSummary, setIncomeSummary] = useState<any>(null);
  const [patients, setPatients] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);

  // Filtros globales (solo para exportar)
  const [startDate, setStartDate] = useState<Date | null>(null);
  const [endDate, setEndDate] = useState<Date | null>(null);
  // Filtros locales para cada sección
  const [appointmentsRange, setAppointmentsRange] = useState<{start: Date | null, end: Date | null}>({start: null, end: null});
  const [incomeRange, setIncomeRange] = useState<{start: Date | null, end: Date | null}>({start: null, end: null});
  const [patientsRange, setPatientsRange] = useState<{start: Date | null, end: Date | null}>({start: null, end: null});

  // Filtros locales
  const [appointmentStatus, setAppointmentStatus] = useState<string>('');
  const [incomeMethod, setIncomeMethod] = useState<string>('');
  const [patientQuery, setPatientQuery] = useState<string>('');

  // Estado para configuración de exportación
  const [exportConfigVisible, setExportConfigVisible] = useState(false);
  const [exportSections, setExportSections] = useState({
    citas: true,
    ingresos: true,
    pacientes: true,
  });

  useEffect(() => {
    fetchReport(); // para exportar
    // eslint-disable-next-line
  }, [reportType, dateRange]);

  useEffect(() => {
    fetchAppointments();
  }, [appointmentsRange]);

  useEffect(() => {
    fetchIncome();
  }, [incomeRange]);

  useEffect(() => {
    fetchPatients();
  }, [patientsRange]);

  const fetchAppointments = async () => {
    setLoading(true);
    try {
      const params: any = {};
      if (appointmentsRange.start && appointmentsRange.end) {
        params.startDate = appointmentsRange.start.toISOString();
        params.endDate = appointmentsRange.end.toISOString();
      }
      const res = await api.get('/appointments', { params });
      setAppointments(res.data);
    } finally {
      setLoading(false);
    }
  };

  const fetchIncome = async () => {
    setLoading(true);
    try {
      const params: any = {};
      if (incomeRange.start && incomeRange.end) {
        params.startDate = incomeRange.start.toISOString();
        params.endDate = incomeRange.end.toISOString();
      }
      const res = await api.get('/payments/summary', { params });
      setIncomeSummary(res.data);
    } finally {
      setLoading(false);
    }
  };

  const fetchPatients = async () => {
    setLoading(true);
    try {
      const params: any = {};
      if (patientsRange.start && patientsRange.end) {
        params.startDate = patientsRange.start.toISOString();
        params.endDate = patientsRange.end.toISOString();
      }
      const res = await api.get('/patients', { params });
      setPatients(res.data);
    } finally {
      setLoading(false);
    }
  };

  const fetchReport = async () => {
    setLoading(true);
    try {
      if (reportType === 'appointments') {
        const params: any = {};
        if (dateRange) {
          params.startDate = dateRange[0].toISOString();
          params.endDate = dateRange[1].toISOString();
        }
        const res = await api.get('/appointments', { params });
        setAppointments(res.data);
      } else if (reportType === 'income') {
        const params: any = {};
        if (dateRange) {
          params.startDate = dateRange[0].toISOString();
          params.endDate = dateRange[1].toISOString();
        }
        const res = await api.get('/payments/summary', { params });
        setIncomeSummary(res.data);
      } else if (reportType === 'patients') {
        const res = await api.get('/patients');
        setPatients(res.data);
      }
    } catch (e) {
      // Aquí puedes poner un toast o alerta
    }
    setLoading(false);
  };

  // Utilidades para transformar datos
  const getAppointmentChartData = () => {
    // Agrupa por mes y estado
    if (!appointments || !Array.isArray(appointments)) return [];
    const grouped: Record<string, { nuevos: number; cancelados: number }> = {};
    appointments.forEach((a: any) => {
      if (appointmentStatus && a.status !== appointmentStatus) return;
      const month = new Date(a.date).toLocaleString('es-MX', { month: 'short' });
      if (!grouped[month]) grouped[month] = { nuevos: 0, cancelados: 0 };
      if (a.status === 'SCHEDULED' || a.status === 'CONFIRMED' || a.status === 'COMPLETED') grouped[month].nuevos++;
      if (a.status === 'CANCELLED') grouped[month].cancelados++;
    });
    return Object.entries(grouped).map(([name, v]) => ({ name, ...v }));
  };

  const getIncomeTableData = () => {
    if (!incomeSummary) return [];
    // Simulación: byMethod y byStatus
    const byMethod = incomeSummary.byMethod || {};
    return Object.entries(byMethod).map(([method, value]) => ({ method, value: Number(value) }));
  };

  const getPatientTableData = () => {
    if (!patients || !Array.isArray(patients)) return [];
    return patients.map((p: any) => ({ name: p.name, email: p.email, phone: p.phone, createdAt: p.createdAt }));
  };

  const formatDateRange = (start: Date | null, end: Date | null) => {
    if (!start || !end) return '';
    return `Del ${start.toLocaleDateString()} al ${end.toLocaleDateString()}`;
  };

  // Exportar datos filtrados de todas las secciones
  const handleExport = async (type: 'csv' | 'pdf') => {
    const citas = exportSections.citas ? getAppointmentChartData() : [];
    const ingresos = exportSections.ingresos ? getIncomeTableData() : [];
    const pacientes = exportSections.pacientes ? getPatientTableData() : [];

    if (type === 'csv') {
      let csv = '';
      if (citas.length) {
        csv += 'Citas Nuevos vs Cancelados\n';
        csv += Papa.unparse(citas) + '\n\n';
      }
      if (ingresos.length) {
        csv += 'Ingresos por Método\n';
        csv += Papa.unparse(ingresos) + '\n\n';
      }
      if (pacientes.length) {
        csv += 'Pacientes\n';
        csv += Papa.unparse(pacientes) + '\n\n';
      }
      const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
      const url = URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', `reportes_${new Date().toISOString().slice(0,10)}.csv`);
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      URL.revokeObjectURL(url);
    } else if (type === 'pdf') {
      const pdf = new jsPDF({ orientation: 'landscape', unit: 'pt', format: 'a4' });
      const pageWidth = pdf.internal.pageSize.getWidth();
      const pageHeight = pdf.internal.pageSize.getHeight();
      const margin = 40;
      let pageIndex = 1;
      let totalPages = 0;
      totalPages += exportSections.citas ? 1 : 0;
      totalPages += exportSections.ingresos ? 1 : 0;
      totalPages += exportSections.pacientes ? 1 : 0;

      // 1. Citas (gráfico como imagen, tabla con AutoTable)
      if (exportSections.citas && citas.length) {
        pdf.setFontSize(22);
        pdf.setTextColor('#ef4444');
        pdf.text('Pacientes Nuevos vs Cancelados', margin + 70, margin + 20);
        pdf.setFontSize(12);
        pdf.setTextColor('#555');
        pdf.text(formatDateRange(appointmentsRange.start, appointmentsRange.end), margin + 70, margin + 38);
        const chartNode = document.querySelector('#seccion-citas .recharts-responsive-container');
        if (chartNode) {
          const canvas = await html2canvas(chartNode as HTMLElement, { scale: 2, backgroundColor: '#fff' });
          const imgData = canvas.toDataURL('image/png');
          pdf.addImage(imgData, 'PNG', margin, margin + 48, 400, 180);
        }
        autoTable(pdf, {
          startY: margin + 240,
          head: [['Nombre', 'Nuevos', 'Cancelados']],
          body: citas.map((row: any) => [row.name, row.nuevos, row.cancelados]),
          theme: 'striped',
          styles: { fontSize: 11, cellPadding: 5, valign: 'middle' },
          headStyles: { fillColor: [239, 68, 68], textColor: 255, fontStyle: 'bold', fontSize: 12 },
          alternateRowStyles: { fillColor: [255, 242, 242] },
          margin: { left: margin, right: margin },
        });
        pdf.setFontSize(10);
        pdf.setTextColor('#888');
        pdf.text('Generado por Sistema Odontos', margin, pageHeight - 15);
        pdf.text(`Página ${pageIndex}/${totalPages}`, pageWidth - margin - 60, pageHeight - 15);
        if (totalPages > pageIndex) pdf.addPage();
        pageIndex++;
      }
      // 2. Ingresos (tabla con AutoTable y opcionalmente gráfica)
      if (exportSections.ingresos && ingresos.length) {
        pdf.setFontSize(22);
        pdf.setTextColor('#ef4444');
        pdf.text('Ingresos por Método', margin + 70, margin + 20);
        pdf.setFontSize(12);
        pdf.setTextColor('#555');
        pdf.text(formatDateRange(incomeRange.start, incomeRange.end), margin + 70, margin + 38);
        const chartNode = document.querySelector('#seccion-ingresos .recharts-responsive-container');
        if (chartNode) {
          const canvas = await html2canvas(chartNode as HTMLElement, { scale: 2, backgroundColor: '#fff' });
          const imgData = canvas.toDataURL('image/png');
          pdf.addImage(imgData, 'PNG', margin, margin + 48, 300, 150);
        }
        autoTable(pdf, {
          startY: margin + 210,
          head: [['Método', 'Ingresos']],
          body: ingresos.map((row: any) => [row.method, `$${row.value.toLocaleString()}`]),
          theme: 'striped',
          styles: { fontSize: 11, cellPadding: 5, valign: 'middle' },
          headStyles: { fillColor: [239, 68, 68], textColor: 255, fontStyle: 'bold', fontSize: 12 },
          alternateRowStyles: { fillColor: [255, 242, 242] },
          margin: { left: margin, right: margin },
        });
        pdf.setFontSize(10);
        pdf.setTextColor('#888');
        pdf.text('Generado por Sistema Odontos', margin, pageHeight - 15);
        pdf.text(`Página ${pageIndex}/${totalPages}`, pageWidth - margin - 60, pageHeight - 15);
        if (totalPages > pageIndex) pdf.addPage();
        pageIndex++;
      }
      // 3. Pacientes (solo tabla)
      if (exportSections.pacientes && pacientes.length) {
        pdf.setFontSize(22);
        pdf.setTextColor('#ef4444');
        pdf.text('Pacientes', margin + 70, margin + 20);
        pdf.setFontSize(12);
        pdf.setTextColor('#555');
        pdf.text(formatDateRange(patientsRange.start, patientsRange.end), margin + 70, margin + 38);
        autoTable(pdf, {
          startY: margin + 48,
          head: [['Nombre', 'Email', 'Teléfono', 'Fecha Registro']],
          body: pacientes.map((row: any) => [row.name, row.email, row.phone, row.createdAt ? new Date(row.createdAt).toLocaleDateString() : '']),
          theme: 'striped',
          styles: { fontSize: 11, cellPadding: 5, valign: 'middle' },
          headStyles: { fillColor: [239, 68, 68], textColor: 255, fontStyle: 'bold', fontSize: 12 },
          alternateRowStyles: { fillColor: [255, 242, 242] },
          margin: { left: margin, right: margin },
        });
        pdf.setFontSize(10);
        pdf.setTextColor('#888');
        pdf.text('Generado por Sistema Odontos', margin, pageHeight - 15);
        pdf.text(`Página ${pageIndex}/${totalPages}`, pageWidth - margin - 60, pageHeight - 15);
      }
      pdf.save(`reportes_${new Date().toISOString().slice(0,10)}.pdf`);
    }
  };

  // Menú de opciones de exportación
  const exportMenu = (
    <Menu>
      <Menu.Item key="csv" onClick={() => handleExport('csv')}>Exportar CSV</Menu.Item>
      <Menu.Item key="pdf" onClick={() => handleExport('pdf')}>Exportar PDF</Menu.Item>
      <Menu.Item key="config" onClick={() => setExportConfigVisible(true)}>Configuración...</Menu.Item>
    </Menu>
  );

  return (
    <DashboardLayout>
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
        <div className="flex items-center gap-4 flex-1 mb-2 sm:mb-0">
          <div className="bg-red-100 text-red-600 rounded-full p-3">
            <ChartBar size={38} weight="duotone" />
          </div>
          <div>
            <h2 className="text-2xl font-bold text-gray-800 mb-1">Reportes y Estadísticas</h2>
            <p className="text-gray-500 text-base font-medium">Análisis y visualización de datos.</p>
          </div>
        </div>
        <div className="flex flex-col md:flex-row gap-2 items-end w-full sm:w-auto">
          <div>
            <label className="block text-xs font-semibold text-gray-700 mb-1">Fecha inicio</label>
            <ModernDatePicker
              value={startDate}
              onChange={setStartDate}
            />
          </div>
          <div>
            <label className="block text-xs font-semibold text-gray-700 mb-1">Fecha fin</label>
            <ModernDatePicker
              value={endDate}
              onChange={setEndDate}
            />
          </div>
          <div className="flex items-end h-full">
            <Dropdown overlay={exportMenu} trigger={['click']} placement="bottomRight">
              <Button
                className="bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-lg transition-all duration-200 shadow-md ml-2 whitespace-nowrap text-base flex items-center"
                icon={<ExportOutlined />}
                style={{ height: 44 }}
              >
                Exportar <DownOutlined className="ml-1" />
              </Button>
            </Dropdown>
          </div>
        </div>
      </div>
      <div id="reportes-seccion">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
          <div id="seccion-citas" className="bg-white rounded-2xl shadow-xl p-6">
            <div className="flex items-center gap-3 mb-4 min-h-[40px]">
              <span className="flex items-center justify-center bg-red-100 text-red-600 rounded-full p-2 shadow-sm" style={{ height: 40, width: 40 }}>
                <ChartBar size={24} weight="duotone" />
              </span>
              <h3 className="text-2xl md:text-3xl font-extrabold tracking-tight text-gray-900 drop-shadow-sm flex items-center" style={{ lineHeight: 1 }}>
                Pacientes Nuevos vs Cancelados
              </h3>
            </div>
            <div className="flex flex-col md:flex-row md:items-center md:justify-between mb-2 gap-2">
              <div className="flex items-center gap-2">
                <div className="flex gap-1 items-end">
                  <ModernDatePicker value={appointmentsRange.start} onChange={d => setAppointmentsRange(r => ({...r, start: d}))} />
                  <span className="inline-block px-1 pb-2 text-xs text-gray-400 align-bottom">a</span>
                  <ModernDatePicker value={appointmentsRange.end} onChange={d => setAppointmentsRange(r => ({...r, end: d}))} />
                </div>
              </div>
              <Select
                value={appointmentStatus}
                onChange={value => setAppointmentStatus(value)}
                className="min-w-[160px] text-xs"
                style={{ width: 180 }}
                options={[
                  { value: '', label: 'Todos los estados' },
                  { value: 'SCHEDULED', label: 'Agendadas' },
                  { value: 'CONFIRMED', label: 'Confirmadas' },
                  { value: 'COMPLETED', label: 'Completadas' },
                  { value: 'CANCELLED', label: 'Canceladas' },
                ]}
                dropdownStyle={{ fontSize: 14, borderRadius: 12, boxShadow: '0 4px 24px #0001' }}
                popupClassName="custom-select-dropdown"
              />
            </div>
            <div className="h-64">
              {loading ? (
                <div className="flex items-center justify-center h-full text-gray-400">Cargando...</div>
              ) : (
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={getAppointmentChartData()} margin={{ top: 10, right: 30, left: 0, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="name" />
                    <YAxis allowDecimals={false} />
                    <Tooltip />
                    <Legend />
                    <Bar dataKey="nuevos" fill="#ef4444" name="Nuevos" />
                    <Bar dataKey="cancelados" fill="#fbbf24" name="Cancelados" />
                  </BarChart>
                </ResponsiveContainer>
              )}
            </div>
          </div>

          <div id="seccion-ingresos" className="bg-white rounded-2xl shadow-xl p-6">
            <div className="flex items-center gap-3 mb-4 min-h-[40px]">
              <span className="flex items-center justify-center bg-red-100 text-red-600 rounded-full p-2 shadow-sm" style={{ height: 40, width: 40 }}>
                <CurrencyDollar size={24} weight="duotone" />
              </span>
              <h3 className="text-2xl md:text-3xl font-extrabold tracking-tight text-gray-900 drop-shadow-sm flex items-center" style={{ lineHeight: 1 }}>
                Ingresos por Método
              </h3>
            </div>
            <div className="flex flex-col md:flex-row md:items-center md:justify-between mb-2 gap-2">
              <div className="flex items-center gap-2">
                <div className="flex gap-1 items-end">
                  <ModernDatePicker value={incomeRange.start} onChange={d => setIncomeRange(r => ({...r, start: d}))} />
                  <span className="inline-block px-1 pb-2 text-xs text-gray-400 align-bottom">a</span>
                  <ModernDatePicker value={incomeRange.end} onChange={d => setIncomeRange(r => ({...r, end: d}))} />
                </div>
              </div>
              <Select
                value={incomeMethod}
                onChange={value => setIncomeMethod(value)}
                className="min-w-[160px] text-xs"
                style={{ width: 180 }}
                options={[
                  { value: '', label: 'Todos los métodos' },
                  ...getIncomeTableData().map(row => ({ value: row.method, label: row.method }))
                ]}
                dropdownStyle={{ fontSize: 14, borderRadius: 12, boxShadow: '0 4px 24px #0001' }}
                popupClassName="custom-select-dropdown"
                showSearch
                filterOption={(input, option) => (option?.label ?? '').toLowerCase().includes(input.toLowerCase())}
              />
            </div>
            <div className="overflow-x-auto">
              {loading ? (
                <div className="flex items-center justify-center h-24 text-gray-400">Cargando...</div>
              ) : (
                <table className="min-w-full divide-y divide-gray-100 rounded-xl overflow-hidden shadow-sm">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Método</th>
                      <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Ingresos</th>
                    </tr>
                  </thead>
                  <tbody>
                    {getIncomeTableData().filter(row => !incomeMethod || row.method === incomeMethod).map((row, idx) => (
                      <tr key={row.method} className="hover:bg-red-50 transition-all border-b border-gray-100">
                        <td className="px-6 py-4 text-sm text-gray-700">{row.method}</td>
                        <td className="px-6 py-4 text-sm text-gray-700 font-semibold">${row.value.toLocaleString()}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              )}
            </div>
          </div>
        </div>

        <div id="seccion-pacientes" className="bg-white rounded-2xl shadow-xl p-6">
          <div className="flex items-center gap-3 mb-4 min-h-[40px]">
            <span className="flex items-center justify-center bg-red-100 text-red-600 rounded-full p-2 shadow-sm" style={{ height: 40, width: 40 }}>
              <User size={24} weight="duotone" />
            </span>
            <h3 className="text-2xl md:text-3xl font-extrabold tracking-tight text-gray-900 drop-shadow-sm flex items-center" style={{ lineHeight: 1 }}>
              Pacientes
            </h3>
          </div>
          <div className="flex flex-col md:flex-row md:items-center md:justify-between mb-2 gap-2">
            <div className="flex items-center gap-2">
              <div className="flex gap-1 items-end">
                <ModernDatePicker value={patientsRange.start} onChange={d => setPatientsRange(r => ({...r, start: d}))} />
                <span className="inline-block px-1 pb-2 text-xs text-gray-400 align-bottom">a</span>
                <ModernDatePicker value={patientsRange.end} onChange={d => setPatientsRange(r => ({...r, end: d}))} />
              </div>
            </div>
            <input
              type="text"
              placeholder="Buscar paciente..."
              value={patientQuery}
              onChange={e => setPatientQuery(e.target.value)}
              className="pl-3 pr-8 py-1 rounded-lg border border-gray-300 text-gray-700 bg-white shadow text-xs"
            />
          </div>
          <div className="overflow-x-auto">
            {loading ? (
              <div className="flex items-center justify-center h-24 text-gray-400">Cargando...</div>
            ) : (
              <table className="min-w-full divide-y divide-gray-100 rounded-xl overflow-hidden shadow-sm">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Nombre</th>
                    <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Email</th>
                    <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Teléfono</th>
                    <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Fecha Registro</th>
                  </tr>
                </thead>
                <tbody>
                  {getPatientTableData().filter(row => {
                    const q = patientQuery.toLowerCase();
                    return (
                      row.name.toLowerCase().includes(q) ||
                      row.email.toLowerCase().includes(q) ||
                      row.phone?.toLowerCase().includes(q)
                    );
                  }).map((row, idx) => (
                    <tr key={row.email} className="hover:bg-red-50 transition-all border-b border-gray-100">
                      <td className="px-6 py-4 text-sm text-gray-700">{row.name}</td>
                      <td className="px-6 py-4 text-sm text-gray-700">{row.email}</td>
                      <td className="px-6 py-4 text-sm text-gray-700">{row.phone}</td>
                      <td className="px-6 py-4 text-sm text-gray-700">{row.createdAt ? new Date(row.createdAt).toLocaleDateString() : ''}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </div>
      </div>
      <Modal
        open={exportConfigVisible}
        onCancel={() => setExportConfigVisible(false)}
        onOk={() => setExportConfigVisible(false)}
        title="Configuración de Exportación"
        okText="Aceptar"
        cancelText="Cancelar"
      >
        <div className="flex flex-col gap-2">
          <Checkbox
            checked={exportSections.citas}
            onChange={e => setExportSections(s => ({ ...s, citas: e.target.checked }))}
          >Citas (gráfico y tabla)</Checkbox>
          <Checkbox
            checked={exportSections.ingresos}
            onChange={e => setExportSections(s => ({ ...s, ingresos: e.target.checked }))}
          >Ingresos</Checkbox>
          <Checkbox
            checked={exportSections.pacientes}
            onChange={e => setExportSections(s => ({ ...s, pacientes: e.target.checked }))}
          >Pacientes</Checkbox>
        </div>
      </Modal>
    </DashboardLayout>
  );
};

export default Reports;