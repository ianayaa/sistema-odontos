import React, { useRef, useState, useEffect, useContext } from 'react';
import FullCalendar from '@fullcalendar/react';
import { DatesSetArg, EventClickArg, EventDropArg, EventInput } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import interactionPlugin from '@fullcalendar/interaction';
import esLocale from '@fullcalendar/core/locales/es';
import { Calendar, Clock, User, Phone, X, Check, WarningCircle, CalendarBlank } from 'phosphor-react';
import { Appointment, AppointmentStatus } from '../types/appointment';
import { Calendar as ModernCalendar, utils } from 'react-modern-calendar-datepicker';
import '../styles/mini-calendar-custom.css';
import { format, parseISO } from 'date-fns';
import AddAppointmentModal from '../components/AddAppointmentModal';
import api, { getDentistSchedule, saveDentistSchedule } from '../services/api';
import { useAuth } from '../context/AuthContext';
import { es } from 'date-fns/locale';
import { registerLocale } from 'react-datepicker';
import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';
import { DateCalendar, PickersDay } from '@mui/x-date-pickers';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { SidebarCollapsedContext } from '../components/DashboardLayout';
import { message } from 'antd';
registerLocale('es', es);

const dayOptions = [
  { value: 0, label: 'Domingo' },
  { value: 1, label: 'Lunes' },
  { value: 2, label: 'Martes' },
  { value: 3, label: 'Miércoles' },
  { value: 4, label: 'Jueves' },
  { value: 5, label: 'Viernes' },
  { value: 6, label: 'Sábado' },
];

const DaySelect = ({ value, onChange }: { value: number; onChange: (v: number) => void }) => {
  const [open, setOpen] = useState(false);
  const selected = dayOptions.find(d => d.value === value);
  return (
    <div className="relative">
      <button
        type="button"
        className="w-full flex items-center gap-2 border border-gray-200 rounded-xl px-3 pr-10 py-2 bg-white text-gray-700 focus:border-yellow-400 focus:ring-2 focus:ring-yellow-100 shadow-sm transition-all hover:border-yellow-300 cursor-pointer"
        onClick={() => setOpen(o => !o)}
        aria-haspopup="listbox"
        aria-expanded={open}
      >
        <Calendar size={18} className="text-yellow-400" />
        <span className={`flex-1 text-left ${selected ? '' : 'text-gray-400'}`}>{selected ? selected.label : 'Selecciona un día'}</span>
        <svg className="absolute right-3 top-1/2 -translate-y-1/2 text-yellow-300" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2.2" viewBox="0 0 24 24"><path d="M6 9l6 6 6-6" /></svg>
      </button>
      {open && (
        <ul className="absolute z-30 mt-2 w-full bg-white rounded-xl shadow-xl border border-gray-100 max-h-56 overflow-y-auto animate-fadeInUp" tabIndex={-1} role="listbox">
          {dayOptions.map(opt => (
            <li
              key={opt.value}
              className={`px-4 py-2 hover:bg-yellow-50 cursor-pointer flex items-center gap-2 ${opt.value === value ? 'bg-yellow-100 font-semibold text-yellow-700' : ''}`}
              onClick={() => {
                onChange(opt.value);
                setOpen(false);
              }}
              role="option"
              aria-selected={opt.value === value}
            >
              <Calendar size={16} className="text-yellow-400" />
              {opt.label}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

const spanish = {
  months: [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ],
  weekDays: [
    { name: 'Domingo', short: 'Dom', isWeekend: true },
    { name: 'Lunes', short: 'Lun' },
    { name: 'Martes', short: 'Mar' },
    { name: 'Miércoles', short: 'Mié' },
    { name: 'Jueves', short: 'Jue' },
    { name: 'Viernes', short: 'Vie' },
    { name: 'Sábado', short: 'Sáb', isWeekend: true }
  ],
  weekStartingIndex: 1,
  getToday: (date: any) => ({ year: date.year, month: date.month, day: date.day }),
  toNativeDate: (date: any) => new Date(date.year, date.month - 1, date.day),
  getMonthLength: (date: any) => new Date(date.year, date.month, 0).getDate(),
  transformDigit: (digit: any) => digit,
  nextMonth: 'Mes siguiente',
  previousMonth: 'Mes anterior',
  openMonthSelector: 'Abrir selector de mes',
  openYearSelector: 'Abrir selector de año',
  closeMonthSelector: 'Cerrar selector de mes',
  closeYearSelector: 'Cerrar selector de año',
  defaultPlaceholder: 'Selecciona...',
  from: 'de',
  to: 'a',
  digitSeparator: ',',
  yearLetterSkip: 0,
  isRtl: false
};

const CalendarAppointments: React.FC = () => {
  const calendarRef = useRef<FullCalendar | null>(null);
  const [selectedDate, setSelectedDate] = useState<Date | null>(null);
  const [showModal, setShowModal] = useState(false);
  const [newDate, setNewDate] = useState<string | null>(null);
  const [modalInfo, setModalInfo] = useState<any>(null);
  const [view, setView] = useState<'timeGridWeek' | 'timeGridDay' | 'dayGridMonth'>(() => {
    return (localStorage.getItem('calendarView') as 'timeGridWeek' | 'timeGridDay' | 'dayGridMonth') || 'timeGridWeek';
  });
  const [businessHours, setBusinessHours] = useState({
    startTime: '08:00',
    endTime: '20:00',
    daysOfWeek: [0, 1, 2, 3, 4, 5, 6],
    blockedHours: [] as { date: string; start: string; end: string }[],
    workingDays: [1, 2, 3, 4, 5] // Lunes a Viernes por defecto
  });
  const [currentDate, setCurrentDate] = useState(() => new Date());
  const [blockModal, setBlockModal] = useState<{
    show: boolean;
    date: Date | null;
    start: string;
    end: string;
  }>({
    show: false,
    date: null,
    start: '',
    end: ''
  });
  const [refresh, setRefresh] = useState(false);
  const [editMode, setEditMode] = useState(false);
  const [editForm, setEditForm] = useState<any>(null);
  const { user } = useAuth();
  const [appointments, setAppointments] = useState<Appointment[]>([]);
  const [newDuration, setNewDuration] = useState<number | undefined>(undefined);
  const [newHour, setNewHour] = useState<string | undefined>(undefined);
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const [calendarKey, setCalendarKey] = useState(0);
  const { isCollapsed } = useContext(SidebarCollapsedContext);

  // Paleta de colores para tratamientos
  const treatmentColors: Record<string, string> = {
    'Limpieza': 'bg-teal-100',
    'Ortodoncia': 'bg-purple-100',
    'Extracción': 'bg-red-100',
    'Resina': 'bg-yellow-100',
    'Endodoncia': 'bg-blue-100',
    'Corona': 'bg-green-100',
    'Prótesis': 'bg-pink-100',
    'Consulta': 'bg-gray-100',
    // Agrega más tratamientos y colores aquí
  };

  // Función para obtener el color según el tratamiento
  function getTreatmentColor(treatment?: string) {
    if (!treatment) return 'bg-gray-50';
    // Normaliza el nombre para evitar problemas de mayúsculas/minúsculas
    const key = treatment.trim().toLowerCase();
    const found = Object.entries(treatmentColors).find(([name]) => name.toLowerCase() === key);
    return found ? found[1] : 'bg-orange-50'; // Color de respaldo
  }

  // Función para determinar el color de texto según el fondo
  function getContrastTextColor(bgColor: string) {
    // Si el color es en formato hex
    let color = bgColor;
    if (color.startsWith('rgb')) {
      // Convertir rgb a hex
      const rgb = color.match(/\d+/g);
      if (rgb && rgb.length >= 3) {
        color = '#' + rgb.slice(0, 3).map(x => (+x).toString(16).padStart(2, '0')).join('');
      }
    }
    if (color.startsWith('#')) {
      const hex = color.replace('#', '');
      const r = parseInt(hex.substring(0, 2), 16);
      const g = parseInt(hex.substring(2, 4), 16);
      const b = parseInt(hex.substring(4, 6), 16);
      // Luminancia relativa
      const luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
      return luminance > 0.6 ? '#222' : '#fff';
    }
    // Si no es hex, usar color oscuro por defecto
    return '#222';
  }

  // Configuración de horarios de trabajo
  const handleBusinessHoursChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    try {
      setBusinessHours(prev => {
        const updated = { ...prev, [name]: value };
        saveDentistSchedule({
          startTime: updated.startTime,
          endTime: updated.endTime,
          workingDays: updated.workingDays,
          blockedHours: updated.blockedHours
        }).catch(error => {
          console.error('Error al guardar horario:', error);
          alert('Error al guardar el horario. Por favor intenta nuevamente.');
        });
        return updated;
      });
      setCalendarKey(k => k + 1);
    } catch (error) {
      console.error('Error al actualizar horario:', error);
      alert('Error al actualizar el horario. Por favor intenta nuevamente.');
    }
  };

  // Manejar días laborables
  const handleWorkingDaysChange = async (day: number) => {
    try {
      setBusinessHours(prev => {
        const newWorkingDays = prev.workingDays.includes(day)
          ? prev.workingDays.filter(d => d !== day)
          : [...prev.workingDays, day].sort((a, b) => a - b);
        
        const updated = {
          ...prev,
          workingDays: newWorkingDays
        };
        saveDentistSchedule({
          startTime: updated.startTime,
          endTime: updated.endTime,
          workingDays: updated.workingDays,
          blockedHours: updated.blockedHours
        }).catch(error => {
          console.error('Error al guardar días laborables:', error);
          alert('Error al guardar los días laborables. Por favor intenta nuevamente.');
        });
        return updated;
      });
    } catch (error) {
      console.error('Error al actualizar días laborables:', error);
      alert('Error al actualizar los días laborables. Por favor intenta nuevamente.');
    }
  };

  // Verificar si un día está seleccionado
  const isDaySelected = (day: number) => {
    return businessHours.workingDays.includes(day);
  };

  // Agregar horario bloqueado
  const handleAddBlockedHour = (date: Date, start: string, end: string) => {
    if (!date || !start || !end) return;
    const dateStr = format(date, 'yyyy-MM-dd');
    // Validar formato de hora
    const timeRegex = /^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/;
    if (!timeRegex.test(start) || !timeRegex.test(end)) {
      message.error('Por favor ingresa un formato de hora válido (HH:MM)');
      return;
    }
    // Convertir a minutos para comparación
    const startMinutes = parseInt(start.split(':')[0]) * 60 + parseInt(start.split(':')[1]);
    const endMinutes = parseInt(end.split(':')[0]) * 60 + parseInt(end.split(':')[1]);
    if (startMinutes >= endMinutes) {
      message.error('La hora de inicio debe ser menor que la hora de fin');
      return;
    }
    // Validar que no se solape con otros horarios bloqueados en la misma fecha
    const hasOverlap = businessHours.blockedHours.some(block => {
      if (block.date !== dateStr) return false;
      const blockStart = parseInt(block.start.split(':')[0]) * 60 + parseInt(block.start.split(':')[1]);
      const blockEnd = parseInt(block.end.split(':')[0]) * 60 + parseInt(block.end.split(':')[1]);
      return (startMinutes >= blockStart && startMinutes < blockEnd) ||
             (endMinutes > blockStart && endMinutes <= blockEnd) ||
             (startMinutes <= blockStart && endMinutes >= blockEnd);
    });
    if (hasOverlap) {
      message.error('Este horario se solapa con otro horario bloqueado para esa fecha');
      return;
    }
    setBusinessHours(prev => {
      const updated = {
        ...prev,
        blockedHours: [...prev.blockedHours, { date: dateStr, start, end }].sort((a, b) => {
          if (a.date !== b.date) return a.date.localeCompare(b.date);
          return a.start.localeCompare(b.start);
        })
      };
      saveDentistSchedule({
        startTime: updated.startTime,
        endTime: updated.endTime,
        workingDays: updated.workingDays,
        blockedHours: updated.blockedHours
      });
      return updated;
    });
    setBlockModal({ show: false, date: null, start: '', end: '' });
  };

  // Eliminar horario bloqueado
  const handleRemoveBlockedHour = (index: number) => {
    setBusinessHours(prev => {
      const updated = {
        ...prev,
        blockedHours: prev.blockedHours.filter((_, i) => i !== index)
      };
      saveDentistSchedule({
        startTime: updated.startTime,
        endTime: updated.endTime,
        workingDays: updated.workingDays,
        blockedHours: updated.blockedHours
      });
      return updated;
    });
  };

  // Colores y estilos por estado
  const statusStyles: Record<AppointmentStatus, { bg: string, border: string, text: string, icon: JSX.Element }> = {
    confirmada: { 
      bg: 'bg-green-50', 
      border: 'border-green-200', 
      text: 'text-green-700',
      icon: <Check size={16} weight="bold" className="text-green-600" />
    },
    cancelada: { 
      bg: 'bg-red-50', 
      border: 'border-red-200', 
      text: 'text-red-700',
      icon: <X size={16} weight="bold" className="text-red-600" />
    },
    pendiente: { 
      bg: 'bg-yellow-50', 
      border: 'border-yellow-200', 
      text: 'text-yellow-700',
      icon: <WarningCircle size={16} weight="bold" className="text-yellow-600" />
    },
    reagendada: { 
      bg: 'bg-blue-50', 
      border: 'border-blue-200', 
      text: 'text-blue-700',
      icon: <Clock size={16} weight="bold" className="text-blue-600" />
    }
  };

  // Eventos para el calendario
  const events: EventInput[] = [
    ...appointments.map(appt => {
      const style = statusStyles[appt.status] || statusStyles.pendiente;
      let end;
      if (appt.endDate) {
        end = appt.endDate;
      } else if (appt.duration) {
        end = new Date(new Date(appt.date).getTime() + appt.duration * 60000);
      } else {
        end = new Date(new Date(appt.date).getTime() + 30 * 60000);
      }
      const bgColor = (appt as any).service?.color || '#f3f4f6';
      const textColor = getContrastTextColor(bgColor);
      return {
        id: appt.id,
        title: '',
        start: appt.date,
        end,
        backgroundColor: 'transparent',
        borderColor: 'transparent',
        textColor: textColor,
        extendedProps: appt,
        classNames: [
          style.bg,
          style.border,
          style.text,
          'p-2',
          'rounded-lg',
          'shadow-sm',
          'hover:shadow-md',
          'transition-all',
          'cursor-pointer'
        ]
      };
    }),
    ...businessHours.blockedHours.map((block, index) => ({
      id: `blocked-${index}`,
      title: 'Horario bloqueado',
      start: `${block.date}T${block.start}`,
      end: `${block.date}T${block.end}`,
      backgroundColor: 'rgba(0, 0, 0, 0.1)',
      borderColor: 'transparent',
      textColor: 'rgba(0, 0, 0, 0.5)',
      classNames: ['opacity-50', 'cursor-not-allowed'],
      extendedProps: { isBlocked: true }
    }))
  ];

  // Maneja el cambio de vista
  const handleViewChange = (newView: 'timeGridWeek' | 'timeGridDay' | 'dayGridMonth') => {
    setView(newView);
    localStorage.setItem('calendarView', newView);
    if (calendarRef.current) {
      calendarRef.current.getApi().changeView(newView);
    }
  };

  // Maneja la navegación a hoy
  const handleToday = () => {
    if (calendarRef.current) {
      calendarRef.current.getApi().today();
      setCurrentDate(new Date());
    }
  };

  // Maneja la navegación anterior/siguiente
  const handleNavigate = (direction: 'prev' | 'next') => {
    if (calendarRef.current) {
      const api = calendarRef.current.getApi();
      if (direction === 'prev') {
        api.prev();
      } else {
        api.next();
      }
      setCurrentDate(api.getDate());
    }
  };

  // Formatea la fecha según la vista actual
  const formatDateTitle = () => {
    if (view === 'timeGridWeek') {
      // Obtener el primer y último día de la semana
      const start = new Date(currentDate);
      const day = start.getDay();
      // Ajustar para que el lunes sea el primer día (ISO)
      const diffToMonday = (day === 0 ? -6 : 1) - day;
      const weekStart = new Date(start);
      weekStart.setDate(start.getDate() + diffToMonday);
      const weekEnd = new Date(weekStart);
      weekEnd.setDate(weekStart.getDate() + 6);
      // Formatear rango
      const optionsDay = { day: 'numeric' as const };
      const optionsMonthYear = { month: 'long' as const, year: 'numeric' as const };
      const startDay = weekStart.toLocaleDateString('es-ES', optionsDay);
      const endDay = weekEnd.toLocaleDateString('es-ES', optionsDay);
      const monthYear = weekEnd.toLocaleDateString('es-ES', optionsMonthYear);
      return `${startDay}–${endDay} de ${monthYear}`;
    } else if (view === 'timeGridDay') {
      return currentDate.toLocaleDateString('es-ES', { year: 'numeric', month: 'long', day: 'numeric' });
    } else {
      return currentDate.toLocaleDateString('es-ES', { year: 'numeric', month: 'long' });
    }
  };

  // Maneja la selección para agendar
  const handleSelect = (selectInfo: any) => {
    const start = new Date(selectInfo.startStr);
    const end = new Date(selectInfo.endStr);
    const day = start.getDay();

    // No permitir seleccionar días no laborables
    if (!businessHours.workingDays.includes(day)) {
      message.warning('Este día no está disponible para agendar citas. Por favor selecciona un día laborable.');
      return;
    }

    // Validar traslape con citas existentes
    const hayTraslape = appointments.some(appt => {
      const apptStart = new Date(appt.date);
      const apptEnd = appt.endDate ? new Date(appt.endDate) : new Date(apptStart.getTime() + (appt.duration || 60) * 60000);
      // Traslape si el inicio de la nueva es antes del fin de la existente y el fin de la nueva es después del inicio de la existente
      return start < apptEnd && end > apptStart;
    });
    if (hayTraslape) {
      alert('Ya existe una cita en ese horario.');
      return;
    }
    // Verificar si la hora seleccionada está dentro de algún rango bloqueado
    const horaActual = start.getHours() * 60 + start.getMinutes();
    const bloqueosFecha = businessHours.blockedHours.filter(b => b.date === format(start, 'yyyy-MM-dd'));
    const bloqueadoPorHora = bloqueosFecha.some(b => {
      const [hStart, mStart] = b.start.split(":").map(Number);
      const [hEnd, mEnd] = b.end.split(":").map(Number);
      const minStart = hStart * 60 + mStart;
      const minEnd = hEnd * 60 + mEnd;
      return horaActual >= minStart && horaActual < minEnd;
    });
    if (bloqueadoPorHora) {
      message.warning("No se puede agendar una cita en un horario bloqueado para esa fecha.");
      return;
    }
    setNewDate(selectInfo.startStr);
    // Calcular duración en minutos si hay rango
    if (selectInfo.endStr && selectInfo.startStr !== selectInfo.endStr) {
      const diffMs = new Date(selectInfo.endStr).getTime() - new Date(selectInfo.startStr).getTime();
      const diffMin = Math.max(Math.round(diffMs / 60000), 15); // mínimo 15 min
      setNewDuration(diffMin);
    } else {
      setNewDuration(undefined);
    }
    // Calcular hora de inicio en formato HH:mm
    const h = start.getHours().toString().padStart(2, '0');
    const m = start.getMinutes().toString().padStart(2, '0');
    setNewHour(`${h}:${m}`);
    setShowModal(true);
  };

  // Maneja el click en una cita
  const handleEventClick = (arg: EventClickArg) => {
    const cita = arg.event.extendedProps;
    setModalInfo(cita);
    setEditForm({
      ...cita,
      date: cita.date ? format(new Date(cita.date), "yyyy-MM-dd'T'HH:mm") : ''
    });
    setEditMode(false);
  };

  // Maneja el drag & drop
  const handleEventDrop = async (arg: EventDropArg) => {
    // Validar si el nuevo horario está bloqueado
    const start = arg.event.start;
    if (!start) return;
    const dateStr = format(start, 'yyyy-MM-dd');
    const horaActual = start.getHours() * 60 + start.getMinutes();
    const bloqueosFecha = businessHours.blockedHours.filter(b => b.date === dateStr);
    const bloqueadoPorHora = bloqueosFecha.some(b => {
      const [hStart, mStart] = b.start.split(":").map(Number);
      const [hEnd, mEnd] = b.end.split(":").map(Number);
      const minStart = hStart * 60 + mStart;
      const minEnd = hEnd * 60 + mEnd;
      return horaActual >= minStart && horaActual < minEnd;
    });
    if (bloqueadoPorHora) {
      message.warning("No se puede mover la cita a un horario bloqueado para esa fecha.");
      arg.revert();
      return;
    }
    try {
      // Actualiza la cita en el backend con la nueva fecha
      await api.put(`/appointments/${arg.event.id}`, {
        date: format(arg.event.start!, "yyyy-MM-dd'T'HH:mm")
      });
      setRefresh(r => !r);
    } catch (error) {
      console.error('Error al actualizar la cita:', error);
      arg.revert();
    }
  };

  // Renderiza el contenido de los eventos
  const renderEventContent = (eventInfo: { 
    event: { extendedProps: any },
    timeText: string 
  }) => {
    const { extendedProps } = eventInfo.event;
    if (extendedProps.isBlocked) {
      return (
        <div className="w-full h-full flex items-center justify-center text-xs text-gray-500 font-semibold">
          Horario bloqueado
        </div>
      );
    }
    const appt = eventInfo.event.extendedProps as Appointment & { service?: { name?: string; color?: string } };
    const bgColor = (appt as any).service?.color || '#f3f4f6';
    const textColor = getContrastTextColor(bgColor);
    let horaInicio = '';
    let horaFin = '';
    if (appt.date) {
      const start = new Date(appt.date);
      horaInicio = start.toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' });
      if (appt.endDate) {
        const end = new Date(appt.endDate);
        horaFin = end.toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' });
      } else if (appt.duration) {
        const end = new Date(start.getTime() + appt.duration * 60000);
        horaFin = end.toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' });
      }
    }
    // Nombre completo del paciente
    const nombreCompleto = [
      appt.patient?.name,
      appt.patient?.lastNamePaterno,
      appt.patient?.lastNameMaterno
    ].filter(Boolean).join(' ');
    return (
      <div
        className="w-full h-full rounded-md relative flex flex-col justify-center overflow-hidden"
        style={{ minHeight: '24px', height: '100%', padding: 0, background: bgColor, border: '1px solid #e5e7eb' }}
      >
        <div className="px-1 py-0.5 flex flex-col justify-center h-full">
          <div className="flex items-center gap-1 w-full">
            <span className="font-semibold text-xs truncate w-full" title={nombreCompleto} style={{ color: textColor }}>{nombreCompleto}</span>
          </div>
          {appt.service?.name && (
            <div className="text-[11px] font-medium truncate w-full" style={{ color: textColor }}>
              {appt.service.name}
            </div>
          )}
          <div className="text-[11px] leading-tight truncate w-full" style={{ color: textColor }}>
            {horaInicio} {horaFin && <span>- {horaFin}</span>}
          </div>
        </div>
      </div>
    );
  };

  // Calcula el slotMaxTime sumando 15 minutos a la hora de cierre
  function getSlotMaxTime(endTime: string) {
    if (!endTime) return '20:00';
    const [h, m] = endTime.split(':').map(Number);
    let date = new Date(1970, 0, 1, h, m);
    date.setMinutes(date.getMinutes() + 15); // suma 15 minutos
    const hh = date.getHours().toString().padStart(2, '0');
    const mm = date.getMinutes().toString().padStart(2, '0');
    return `${hh}:${mm}`;
  }

  // Agrega esta función dentro del componente CalendarAppointments
  function getDayClassName(day: Date) {
    if (!currentDate) return '';
    const selected = new Date(currentDate);
    // Lunes = 1, Domingo = 0 (ajuste para que la semana inicie en lunes)
    const startOfWeek = new Date(selected);
    startOfWeek.setDate(selected.getDate() - ((selected.getDay() + 6) % 7));
    const endOfWeek = new Date(startOfWeek);
    endOfWeek.setDate(startOfWeek.getDate() + 6);
    const isInWeek = day >= startOfWeek && day <= endOfWeek;
    const isFirst = day.getDay() === 1;
    const isLast = day.getDay() === 0;
    let className = '';
    if (isInWeek) className += ' week-highlight';
    if (isInWeek && isFirst) className += ' first-in-row';
    if (isInWeek && isLast) className += ' last-in-row';
    return className;
  }

  useEffect(() => {
    if (!user) return;
    let url = '/appointments';
    if (user.role === 'DENTIST') {
      url += `?dentistId=${user.id}`;
    }
    api.get(url)
      .then(res => setAppointments(res.data));
    // Cargar horarios/bloqueos del backend
    getDentistSchedule().then(data => {
      if (data) {
        setBusinessHours(prev => ({
          startTime: data.startTime || '08:00',
          endTime: data.endTime || '20:00',
          workingDays: data.workingDays || [1,2,3,4,5],
          blockedHours: data.blockedHours || [],
          daysOfWeek: prev.daysOfWeek || [0,1,2,3,4,5,6]
        }));
      }
    });
  }, [user, refresh]);

  useEffect(() => {
    setCurrentDate(new Date());
  }, []);

  // Forzar re-render del calendario cuando cambia el estado del menú colapsado
  useEffect(() => {
    window.dispatchEvent(new Event('resize'));
  }, [isCollapsed]);

  // Ajuste automático con ResizeObserver
  const calendarContainerRef = useRef<HTMLDivElement>(null);
  useEffect(() => {
    if (!calendarContainerRef.current || !calendarRef.current) return;
    const observer = new window.ResizeObserver(() => {
      try {
        calendarRef.current?.getApi().updateSize();
      } catch (e) {}
    });
    observer.observe(calendarContainerRef.current);
    return () => {
      observer.disconnect();
    };
  }, []);

  return (
    <div className="flex gap-4 h-full" style={{ minHeight: 'calc(100vh - 120px)' }}>
      {/* Botón flotante para mostrar el menú lateral si está oculto */}
      {!sidebarOpen && (
        <button
          className="fixed top-24 left-4 z-40 bg-red-500 text-white rounded-full shadow-lg p-3 hover:bg-red-600 transition-all"
          onClick={() => setSidebarOpen(true)}
          title="Mostrar configuración"
        >
          <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 12h16M4 6h16M4 18h16" /></svg>
        </button>
      )}
      {/* Calendario lateral */}
      {sidebarOpen && (
        <div className="w-80 h-full bg-white rounded-xl shadow-sm p-4 hidden md:block border border-gray-100 relative mr-6 overflow-y-auto" style={{ zIndex: 10, maxHeight: 'calc(100vh - 120px)' }}>
          <h3 className="text-xl font-bold text-gray-800 mb-2 flex items-center gap-2">
            <Clock size={22} className="text-red-500" /> Configuración
          </h3>
          <p className="text-xs text-gray-500 mb-4">Ajusta los parámetros de tu agenda y bloquea horarios no disponibles.</p>
          {/* Mini calendario mensual */}
          <div className="mb-4">
            <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={es}>
              <DateCalendar
                value={currentDate}
                referenceDate={currentDate}
                onChange={(date) => {
                  if (date) {
                    setCurrentDate(date);
                    setView('timeGridDay');
                    if (calendarRef.current) {
                      const api = calendarRef.current.getApi();
                      api.changeView('timeGridDay', date);
                    }
                  }
                }}
                showDaysOutsideCurrentMonth={false}
                displayWeekNumber={false}
                disableHighlightToday={true}
                views={['day']}
                sx={{
                  borderRadius: 3,
                  boxShadow: 3,
                  bgcolor: '#fff',
                  width: '100%',
                  minWidth: 0,
                  maxWidth: '100%',
                  p: 0,
                  margin: 0,
                  overflow: 'hidden',
                  '& .MuiPickersDay-root': {
                    fontWeight: 400,
                    fontSize: '1rem',
                    minWidth: '2.2rem',
                    height: '2.5rem',
                    borderRadius: 12,
                    position: 'relative',
                  },
                  '& .Mui-selected': {
                    background: 'linear-gradient(135deg, #2563eb 60%, #60a5fa 100%)',
                    color: '#fff',
                    zIndex: 2,
                  },
                  '& .MuiPickersDay-root.week-highlight': {
                    background: 'rgba(37,99,235,0.10)',
                    borderRadius: 10,
                  },
                  '& .MuiPickersDay-root.week-highlight.first-in-row': {
                    borderTopLeftRadius: 10,
                    borderBottomLeftRadius: 10,
                  },
                  '& .MuiPickersDay-root.week-highlight.last-in-row': {
                    borderTopRightRadius: 10,
                    borderBottomRightRadius: 10,
                  },
                  '& .MuiPickersCalendarHeader-label': {
                    fontSize: '1rem',
                    fontWeight: 700,
                    textTransform: 'capitalize',
                  },
                  '& .MuiDayCalendar-weekContainer': {
                    justifyContent: 'flex-start',
                    display: 'flex',
                  },
                }}
                dayOfWeekFormatter={(date) => {
                  const label = date.toLocaleDateString('es-MX', { weekday: 'short' });
                  return label.charAt(0).toUpperCase() + label.slice(1);
                }}
                slots={{
                  day: (props: any) => {
                    const { day, selected, ...rest } = props;
                    const today = new Date();
                    const isToday =
                      day.getDate() === today.getDate() &&
                      day.getMonth() === today.getMonth() &&
                      day.getFullYear() === today.getFullYear();
                    const selectedDate = currentDate;
                    const startOfWeek = new Date(selectedDate);
                    startOfWeek.setDate(selectedDate.getDate() - ((selectedDate.getDay() + 6) % 7));
                    const endOfWeek = new Date(startOfWeek);
                    endOfWeek.setDate(startOfWeek.getDate() + 6);
                    const isInWeek = day >= startOfWeek && day <= endOfWeek;
                    const isFirst = day.getDay() === 1;
                    const isLast = day.getDay() === 0;
                    let className = '';
                    if (isInWeek) className += ' week-highlight';
                    if (isInWeek && isFirst) className += ' first-in-row';
                    if (isInWeek && isLast) className += ' last-in-row';
                    return (
                      <PickersDay
                        {...rest}
                        day={day}
                        selected={selected}
                        className={className}
                        sx={isToday ? {
                          background: '#2563eb !important',
                          color: '#fff !important',
                          border: 'none',
                          fontWeight: 700,
                        } : {}}
                      />
                    );
                  }
                }}
              />
            </LocalizationProvider>
          </div>
          <div className="space-y-6">
            {/* Horario de trabajo */}
            <div className="p-3 rounded-lg bg-red-50 border border-red-100">
              <h4 className="text-sm font-semibold text-red-700 mb-2">Horario de trabajo</h4>
              <div className="grid grid-cols-2 gap-2">
                <div>
                  <label className="block text-xs text-gray-500 mb-1">Apertura</label>
                  <DatePicker
                    selected={businessHours.startTime ? new Date(`1970-01-01T${businessHours.startTime}:00`) : null}
                    onChange={(date: Date | null) => {
                      const newTime = date ? format(date, 'HH:mm') : '';
                      setBusinessHours(prev => {
                        const updated = { ...prev, startTime: newTime };
                        saveDentistSchedule({
                          startTime: updated.startTime,
                          endTime: updated.endTime,
                          workingDays: updated.workingDays,
                          blockedHours: updated.blockedHours
                        }).catch(error => {
                          alert('Error al guardar el horario. Intenta de nuevo.');
                        });
                        return updated;
                      });
                      setCalendarKey(k => k + 1);
                    }}
                    showTimeSelect
                    showTimeSelectOnly
                    timeIntervals={15}
                    timeCaption="Hora"
                    dateFormat="h:mm aa"
                    className="w-full border-2 border-blue-200 rounded-xl px-3 py-2 bg-blue-50 text-gray-700 focus:border-blue-400 focus:ring-2 focus:ring-blue-100 transition-all"
                    placeholderText="Selecciona hora"
                  />
                </div>
                <div>
                  <label className="block text-xs text-gray-500 mb-1">Cierre</label>
                  <DatePicker
                    selected={businessHours.endTime ? new Date(`1970-01-01T${businessHours.endTime}:00`) : null}
                    onChange={(date: Date | null) => {
                      const newTime = date ? format(date, 'HH:mm') : '';
                      setBusinessHours(prev => {
                        const updated = { ...prev, endTime: newTime };
                        saveDentistSchedule({
                          startTime: updated.startTime,
                          endTime: updated.endTime,
                          workingDays: updated.workingDays,
                          blockedHours: updated.blockedHours
                        }).catch(error => {
                          alert('Error al guardar el horario. Intenta de nuevo.');
                        });
                        return updated;
                      });
                      setCalendarKey(k => k + 1);
                    }}
                    showTimeSelect
                    showTimeSelectOnly
                    timeIntervals={15}
                    timeCaption="Hora"
                    dateFormat="h:mm aa"
                    className="w-full border-2 border-blue-200 rounded-xl px-3 py-2 bg-blue-50 text-gray-700 focus:border-blue-400 focus:ring-2 focus:ring-blue-100 transition-all"
                    placeholderText="Selecciona hora"
                  />
                </div>
              </div>
            </div>

            {/* Días laborables */}
            <div className="p-3 rounded-lg bg-gray-50 border border-gray-100">
              <h4 className="text-sm font-semibold text-gray-700 mb-2">Días laborables</h4>
              <p className="text-xs text-gray-500 mb-2">Haz clic para activar o desactivar un día.</p>
              <div className="flex flex-wrap gap-2">
                {[
                  { label: 'Lun', value: 1 },
                  { label: 'Mar', value: 2 },
                  { label: 'Mié', value: 3 },
                  { label: 'Jue', value: 4 },
                  { label: 'Vie', value: 5 },
                  { label: 'Sáb', value: 6 },
                  { label: 'Dom', value: 0 }
                ].map(({ label, value }) => (
                  <button
                    key={value}
                    onClick={() => handleWorkingDaysChange(value)}
                    className={`px-3 py-2 rounded-lg text-sm font-semibold border transition-all duration-150 focus:outline-none focus:ring-2 focus:ring-red-200 ${
                      isDaySelected(value)
                        ? 'bg-red-500 text-white border-red-500 shadow-sm scale-105'
                        : 'bg-white text-gray-600 border-gray-200 hover:bg-red-50 hover:border-red-300'
                    }`}
                    aria-pressed={isDaySelected(value)}
                    aria-label={`Día ${label} ${isDaySelected(value) ? 'activo' : 'inactivo'}`}
                  >
                    {label}
                  </button>
                ))}
              </div>
            </div>

            {/* Bloquear horario */}
            <div className="p-3 rounded-lg bg-yellow-50 border border-yellow-100">
              <h4 className="text-sm font-semibold text-yellow-700 mb-2">Bloquear horario</h4>
              <p className="text-xs text-gray-500 mb-2">Selecciona un día y un rango de horas para bloquear.</p>
              <form
                className="flex flex-col gap-3"
                onSubmit={e => {
                  e.preventDefault();
                  if (!blockModal.date) return;
                  handleAddBlockedHour(blockModal.date, blockModal.start, blockModal.end);
                }}
              >
                <div className="flex flex-col gap-2 w-full">
                  <div className="flex flex-col w-full">
                    <label className="text-xs text-gray-600 mb-1">Fecha</label>
                    <DatePicker
                      selected={blockModal.date}
                      onChange={(date: Date | null) => setBlockModal(prev => ({ ...prev, date }))}
                      dateFormat="yyyy-MM-dd"
                      className="w-full border-2 border-blue-200 rounded-xl px-3 py-2 bg-blue-50 text-gray-700 focus:border-blue-400 focus:ring-2 focus:ring-blue-100 transition-all"
                      placeholderText="Selecciona fecha"
                    />
                  </div>
                  <div className="flex flex-col w-full">
                    <label className="text-xs text-gray-600 mb-1">Hora inicio</label>
                    <DatePicker
                      selected={blockModal.start ? new Date(`1970-01-01T${blockModal.start}:00`) : null}
                      onChange={(date: Date | null) => setBlockModal(prev => ({ ...prev, start: date ? format(date, 'HH:mm') : '' }))}
                      showTimeSelect
                      showTimeSelectOnly
                      timeIntervals={15}
                      timeCaption="Hora"
                      dateFormat="h:mm aa"
                      className="w-full border-2 border-blue-200 rounded-xl px-3 py-2 bg-blue-50 text-gray-700 focus:border-blue-400 focus:ring-2 focus:ring-blue-100 transition-all"
                      placeholderText="Selecciona hora"
                    />
                  </div>
                  <span className="text-center text-gray-400 text-xs">a</span>
                  <div className="flex flex-col w-full">
                    <label className="text-xs text-gray-600 mb-1">Hora fin</label>
                    <DatePicker
                      selected={blockModal.end ? new Date(`1970-01-01T${blockModal.end}:00`) : null}
                      onChange={(date: Date | null) => setBlockModal(prev => ({ ...prev, end: date ? format(date, 'HH:mm') : '' }))}
                      showTimeSelect
                      showTimeSelectOnly
                      timeIntervals={15}
                      timeCaption="Hora"
                      dateFormat="h:mm aa"
                      className="w-full border-2 border-blue-200 rounded-xl px-3 py-2 bg-blue-50 text-gray-700 focus:border-blue-400 focus:ring-2 focus:ring-blue-100 transition-all"
                      placeholderText="Selecciona hora"
                    />
                  </div>
                </div>
                <button
                  type="submit"
                  className="px-3 py-2 rounded-lg bg-yellow-500 text-white font-semibold text-sm hover:bg-yellow-600 transition-all w-full mt-1"
                  disabled={!blockModal.date || !blockModal.start || !blockModal.end}
                >
                  Agregar
                </button>
              </form>
              <div className="mt-3">
                <h5 className="text-xs font-semibold text-gray-700 mb-1">Horarios bloqueados</h5>
                {businessHours.blockedHours.length === 0 ? (
                  <div className="text-xs text-gray-400">No hay horarios bloqueados.</div>
                ) : (
                  <ul className="space-y-1">
                    {businessHours.blockedHours.map((block, index) => (
                      <li key={index} className="flex items-center justify-between bg-white border border-gray-200 rounded-lg px-2 py-1 text-xs">
                        <span>
                          <b>{block.date}</b>: {block.start} - {block.end}
                        </span>
                        <button
                          onClick={() => handleRemoveBlockedHour(index)}
                          className="ml-2 text-red-500 hover:text-red-700"
                          title="Eliminar bloqueo"
                          aria-label="Eliminar bloqueo"
                        >
                          <X size={14} />
                        </button>
                      </li>
                    ))}
                  </ul>
                )}
              </div>
            </div>

            {/* Leyenda */}
            <div className="p-3 rounded-lg bg-gray-50 border border-gray-100">
              <h4 className="text-sm font-semibold text-gray-700 mb-2">Leyenda</h4>
              <div className="space-y-2">
                {Object.entries(statusStyles).map(([status, style]) => (
                  <div key={status} className="flex items-center gap-2">
                    <div className={`w-4 h-4 rounded-full ${style.bg} ${style.border}`} />
                    <span className="text-xs capitalize">{status}</span>
                  </div>
                ))}
                <div className="flex items-center gap-2">
                  <div className="w-4 h-4 rounded-full bg-gray-100 border border-gray-200" />
                  <span className="text-xs">Horario bloqueado</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Calendario grande */}
      <div ref={calendarContainerRef} className="flex-1 bg-white rounded-xl shadow-sm overflow-hidden h-full">
        <div className="p-4 border-b border-gray-200 bg-fef2f2 shadow-md rounded-t-xl">
          <div className="flex flex-wrap items-center justify-between gap-4">
            <div className="flex items-center gap-2">
              <button
                onClick={() => handleNavigate('prev')}
                className="p-2 rounded-full text-red-500 bg-white border border-red-100 shadow hover:bg-red-50 hover:scale-110 transition-all"
                title="Anterior"
              >
                <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                  <path fillRule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clipRule="evenodd" />
                </svg>
              </button>
              <h2 className="text-xl font-extrabold text-gray-800 min-w-[200px] text-center drop-shadow-sm tracking-tight">
                {formatDateTitle()}
              </h2>
              <button
                onClick={() => handleNavigate('next')}
                className="p-2 rounded-full text-red-500 bg-white border border-red-100 shadow hover:bg-red-50 hover:scale-110 transition-all"
                title="Siguiente"
              >
                <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                  <path fillRule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clipRule="evenodd" />
                </svg>
              </button>
            </div>
            <div className="flex items-center gap-2 bg-white/70 px-2 py-1 rounded-xl shadow-sm border border-gray-100">
              <button
                onClick={() => handleViewChange('dayGridMonth')}
                className={`px-3 py-1 rounded-lg text-sm font-bold flex items-center gap-1 transition-all ${
                  view === 'dayGridMonth' 
                    ? 'bg-red-200 text-red-700 shadow' 
                    : 'bg-gray-100 text-gray-600 hover:bg-red-50 hover:text-red-700'
                }`}
                title="Vista mensual"
              >
                <Calendar className="inline-block" size={18} /> Mes
              </button>
              <button
                onClick={() => handleViewChange('timeGridWeek')}
                className={`px-3 py-1 rounded-lg text-sm font-bold flex items-center gap-1 transition-all ${
                  view === 'timeGridWeek' 
                    ? 'bg-red-200 text-red-700 shadow' 
                    : 'bg-gray-100 text-gray-600 hover:bg-red-50 hover:text-red-700'
                }`}
                title="Vista semanal"
              >
                <Clock className="inline-block" size={18} /> Semana
              </button>
              <button
                onClick={() => handleViewChange('timeGridDay')}
                className={`px-3 py-1 rounded-lg text-sm font-bold flex items-center gap-1 transition-all ${
                  view === 'timeGridDay' 
                    ? 'bg-red-200 text-red-700 shadow' 
                    : 'bg-gray-100 text-gray-600 hover:bg-red-50 hover:text-red-700'
                }`}
                title="Vista diaria"
              >
                <CalendarBlank className="inline-block" size={18} /> Día
              </button>
            </div>
            <div className="flex items-center gap-2">
              <button
                onClick={handleToday}
                className="px-4 py-2 rounded-lg bg-red-500 text-white text-sm font-bold shadow hover:bg-red-600 transition-all"
                title="Ir a hoy"
              >
                Hoy
              </button>
            </div>
          </div>
        </div>

        <FullCalendar
          ref={calendarRef}
          plugins={[dayGridPlugin, timeGridPlugin, interactionPlugin]}
          initialView={view}
          headerToolbar={false}
          events={events}
          locale={esLocale}
          height={"calc(100vh - 120px)"}
          allDaySlot={false}
          slotMinTime={businessHours.startTime}
          slotMaxTime={getSlotMaxTime(businessHours.endTime)}
          slotDuration="00:15:00"
          expandRows={true}
          stickyHeaderDates={true}
          nowIndicator={true}
          selectable={true}
          selectMirror={true}
          select={handleSelect}
          selectAllow={(selectInfo) => {
            const start = selectInfo.start;
            const end = selectInfo.end;
            const dateStr = format(start, 'yyyy-MM-dd');
            const horaInicio = start.getHours() * 60 + start.getMinutes();
            const horaFin = end.getHours() * 60 + end.getMinutes();
            const bloqueosFecha = businessHours.blockedHours.filter(b => b.date === dateStr);
            for (const block of bloqueosFecha) {
              const blockStart = parseInt(block.start.split(':')[0]) * 60 + parseInt(block.start.split(':')[1]);
              const blockEnd = parseInt(block.end.split(':')[0]) * 60 + parseInt(block.end.split(':')[1]);
              if ((horaInicio < blockEnd && horaFin > blockStart)) {
                return false;
              }
            }
            return true;
          }}
          eventClick={handleEventClick}
          editable={true}
          eventDrop={handleEventDrop}
          eventContent={renderEventContent}
          datesSet={(dateInfo) => {
            const today = new Date();
            if (currentDate.toDateString() === today.toDateString()) return;
            setCurrentDate(dateInfo.start);
          }}
          businessHours={{
            daysOfWeek: businessHours.workingDays,
            startTime: businessHours.startTime,
            endTime: businessHours.endTime
          }}
          eventTimeFormat={{
            hour: '2-digit',
            minute: '2-digit',
            hour12: false
          }}
          views={{
            timeGridWeek: {
              titleFormat: { year: 'numeric', month: 'long', day: 'numeric' },
              slotLabelFormat: { hour: '2-digit', minute: '2-digit', hour12: false }
            },
            timeGridDay: {
              titleFormat: { year: 'numeric', month: 'long', day: 'numeric' },
              slotLabelFormat: { hour: '2-digit', minute: '2-digit', hour12: false }
            },
            dayGridMonth: {
              titleFormat: { year: 'numeric', month: 'long' }
            }
          }}
          dayHeaderFormat={{ weekday: 'long', day: 'numeric' }}
          dayHeaderContent={args => {
            // Capitaliza la primera letra del día
            const text = args.text;
            return text.charAt(0).toUpperCase() + text.slice(1);
          }}
          dayMaxEvents={true}
          moreLinkText="+%d más"
          moreLinkClick="popover"
          eventMaxStack={2}
          eventOrder="start,-duration,title"
          eventDidMount={(info) => {
            const paciente = [
              info.event.extendedProps.patient?.name,
              info.event.extendedProps.patient?.lastNamePaterno,
              info.event.extendedProps.patient?.lastNameMaterno
            ].filter(Boolean).join(' ');
            const servicio = info.event.extendedProps.service?.name || 'No especificado';
            const color = info.event.extendedProps.service?.color || '#f3f4f6';
            const telefono = info.event.extendedProps.patient?.phone || 'No registrado';
            const doctor = info.event.extendedProps.doctor || 'No asignado';
            const tratamiento = info.event.extendedProps.treatment || '';
            const notas = info.event.extendedProps.notes || 'Sin notas';
            //tooltip
            const tooltip = document.createElement('div');
            tooltip.innerHTML = `
              <div style="font-family: inherit; min-width:220px; max-width:320px; background: white; border-radius: 1rem; box-shadow: 0 4px 24px 0 #0002; border: 1px solid #eee; padding: 1rem;">
                <div style="display:flex; align-items:center; gap:8px; margin-bottom:6px;">
                  <span style="display:inline-block; width:18px; height:18px; border-radius:50%; border:1px solid #eee; background:${color};"></span>
                  <span style="font-weight:600; color:#e11d48;">${paciente}</span>
                </div>
                <div style="font-size:15px; color:#222; margin-bottom:4px;"><b>Servicio:</b> ${servicio}</div>
                ${tratamiento ? `<div style='font-size:14px; color:#2563eb; margin-bottom:4px;'><b>Tratamiento:</b> ${tratamiento}</div>` : ''}
                <div style="font-size:14px; color:#444; margin-bottom:2px;"><b>Teléfono:</b> ${telefono}</div>
                <div style="font-size:14px; color:#444; margin-bottom:2px;"><b>Doctor:</b> ${doctor}</div>
                <div style="font-size:14px; color:#444; margin-bottom:2px;"><b>Notas:</b> ${notas}</div>
              </div>
            `;
            tooltip.style.position = 'absolute';
            tooltip.style.zIndex = '9999';
            tooltip.style.pointerEvents = 'none';
            let timeout: any;
            info.el.addEventListener('mouseenter', (e: MouseEvent) => {
              document.body.appendChild(tooltip);
              const rect = (e.target as HTMLElement).getBoundingClientRect();
              tooltip.style.top = `${rect.bottom + window.scrollY + 8}px`;
              tooltip.style.left = `${rect.left + window.scrollX}px`;
              timeout = setTimeout(() => tooltip.style.opacity = '1', 100);
            });
            info.el.addEventListener('mouseleave', () => {
              tooltip.remove();
              clearTimeout(timeout);
            });
          }}
          key={`${calendarKey}-${isCollapsed}`}
        />
      </div>

      {/* Modal de detalles de cita */}
      {modalInfo && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-lg p-0 relative overflow-hidden animate-fadeInUp">
            <div className="flex items-center gap-3 bg-gradient-to-r from-red-100 to-red-50 px-8 py-6 border-b border-red-100">
              <div className="bg-red-200 text-red-600 rounded-full p-3">
                <Calendar size={30} weight="duotone" />
              </div>
              <div className="flex-1">
                <h3 className="text-xl font-bold text-gray-800">Detalles de la cita</h3>
                <div className="text-gray-400 text-sm">Puedes reagendar, cancelar o eliminar la cita</div>
              </div>
              <button
                className="ml-auto text-gray-400 hover:text-red-600 text-2xl font-bold p-1 rounded-full transition-colors focus:outline-none"
                onClick={() => setModalInfo(null)}
                aria-label="Cerrar"
                type="button"
              >
                <svg width="28" height="28" fill="none" stroke="#e11d48" strokeWidth="2.2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M15 9l-6 6M9 9l6 6"/></svg>
              </button>
            </div>
            {editMode ? (
              <form
                onSubmit={async e => {
                  e.preventDefault();
                  await api.put(`/appointments/${editForm.id}`, editForm);
                  setModalInfo(null);
                  setRefresh(r => !r);
                }}
                className="space-y-4 px-8 py-7"
              >
                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1">Paciente</label>
                  <input
                    type="text"
                    value={editForm.patient?.name || ''}
                    disabled
                    className="w-full border border-gray-200 rounded-xl px-3 py-2 bg-gray-50 text-gray-700"
                  />
                </div>
                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1">Fecha y hora</label>
                  <input
                    type="datetime-local"
                    value={editForm.date ? editForm.date.substring(0, 16) : ''}
                    onChange={(e) => setEditForm((f: any) => ({ ...f, date: e.target.value }))}
                    className="w-full border border-gray-200 rounded-xl px-3 py-2 bg-gray-50 text-gray-700"
                  />
                </div>
                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1">Estado</label>
                  <select
                    value={editForm.status}
                    onChange={(e) => setEditForm((f: any) => ({ ...f, status: e.target.value }))}
                    className="w-full border border-gray-200 rounded-xl px-3 py-2 bg-gray-50 text-gray-700"
                  >
                    <option value="pendiente">Pendiente</option>
                    <option value="confirmada">Confirmada</option>
                    <option value="cancelada">Cancelada</option>
                    <option value="reagendada">Reagendada</option>
                  </select>
                </div>
                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1">Notas</label>
                  <textarea
                    value={editForm.notes || ''}
                    onChange={(e) => setEditForm((f: any) => ({ ...f, notes: e.target.value }))}
                    className="w-full border border-gray-200 rounded-xl px-3 py-2 bg-gray-50 text-gray-700"
                    rows={2}
                  />
                </div>
                <div className="flex flex-col gap-2 mt-4">
                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-2">
                    <button
                      type="button"
                      onClick={async () => {
                        await api.delete(`/appointments/${editForm.id}`);
                        setModalInfo(null);
                        setRefresh(r => !r);
                      }}
                      className="flex items-center justify-center gap-1 px-2.5 py-1.5 bg-red-500 text-white rounded-lg shadow-sm hover:bg-red-600 transition-all font-medium text-sm focus:outline-none focus:ring-1 focus:ring-red-200"
                    >
                      <X size={16} weight='bold' /> Eliminar
                    </button>
                    {!editMode && (
                      <button
                        type="button"
                        onClick={() => setEditForm((f: any) => ({ ...f, status: 'cancelada' }))}
                        className="flex items-center justify-center gap-1 px-2.5 py-1.5 bg-yellow-400 text-yellow-900 rounded-lg shadow-sm hover:bg-yellow-500 transition-all font-medium text-sm focus:outline-none focus:ring-1 focus:ring-yellow-200"
                      >
                        <WarningCircle size={16} weight='bold' /> Cancelar cita
                      </button>
                    )}
                    <button
                      type="submit"
                      className="flex items-center justify-center gap-1 px-2.5 py-1.5 bg-blue-600 text-white rounded-lg shadow-sm hover:bg-blue-700 transition-all font-medium text-sm focus:outline-none focus:ring-1 focus:ring-blue-200"
                    >
                      <Check size={16} weight='bold' /> Guardar
                    </button>
                  </div>
                </div>
              </form>
            ) : (
              <div className="space-y-3 px-8 py-7">
                <div className="flex items-center gap-2">
                  <User size={20} weight="bold" className="text-red-600" />
                  <span className="font-medium">
                    {modalInfo.patient?.name}
                    {modalInfo.patient?.lastNamePaterno ? ' ' + modalInfo.patient.lastNamePaterno : ''}
                    {modalInfo.patient?.lastNameMaterno ? ' ' + modalInfo.patient.lastNameMaterno : ''}
                  </span>
                </div>
                <div className="flex items-center gap-2">
                  <Phone size={20} weight="bold" className="text-red-600" />
                  <span>{modalInfo.patient?.phone || 'No registrado'}</span>
                </div>
                <div className="flex items-center gap-2">
                  <Clock size={20} weight="bold" className="text-red-600" />
                  <span>{new Date(modalInfo.date).toLocaleString('es-ES')}</span>
                </div>
                <div className="pt-2">
                  <span className="font-medium">Doctor:</span>
                  <p className="text-gray-600">{modalInfo.doctor || 'No asignado'}</p>
                </div>
                <div className="pt-2">
                  <span className="font-medium">Tratamiento:</span>
                  <div className="flex items-center gap-2">
                    {modalInfo.service?.color && (
                      <span className="inline-block w-4 h-4 rounded-full border border-gray-200" style={{ background: modalInfo.service.color }}></span>
                    )}
                    <span className="text-gray-800 break-words whitespace-pre-line">
                      {modalInfo.service?.name || 'No especificado'}
                    </span>
                  </div>
                  {modalInfo.treatment && (
                    <p className="text-gray-600 text-xs mt-1">{modalInfo.treatment}</p>
                  )}
                </div>
                <div className="pt-2">
                  <span className="font-medium">Notas:</span>
                  <p className="text-gray-600">{modalInfo.notes || 'Sin notas'}</p>
                </div>
                <div className="flex flex-col gap-2 mt-4">
                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-2">
                    <button
                      onClick={() => setEditMode(true)}
                      className="flex items-center justify-center gap-1 px-2.5 py-1.5 bg-blue-100 text-blue-700 rounded-lg shadow-sm hover:bg-blue-200 transition-all font-medium text-sm focus:outline-none focus:ring-1 focus:ring-blue-200"
                    >
                      <Clock size={16} weight='bold' /> Reagendar
                    </button>
                    <button
                      onClick={async () => {
                        await api.delete(`/appointments/${modalInfo.id}`);
                        setModalInfo(null);
                        setRefresh(r => !r);
                      }}
                      className="flex items-center justify-center gap-1 px-2.5 py-1.5 bg-red-500 text-white rounded-lg shadow-sm hover:bg-red-600 transition-all font-medium text-sm focus:outline-none focus:ring-1 focus:ring-red-200"
                    >
                      <X size={16} weight='bold' /> Eliminar
                    </button>
                    {!editMode && (
                      <button
                        onClick={async () => {
                          await api.put(`/appointments/${modalInfo.id}`, { ...modalInfo, status: 'cancelada' });
                          setModalInfo(null);
                          setRefresh(r => !r);
                        }}
                        className="flex items-center justify-center gap-1 px-2.5 py-1.5 bg-yellow-400 text-yellow-900 rounded-lg shadow-sm hover:bg-yellow-500 transition-all font-medium text-sm focus:outline-none focus:ring-1 focus:ring-yellow-200"
                      >
                        <WarningCircle size={16} weight='bold' /> Cancelar cita
                      </button>
                    )}
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>
      )}

      {showModal && (
        <AddAppointmentModal
          onClose={() => setShowModal(false)}
          onSuccess={() => {
            setShowModal(false);
            setRefresh(r => !r);
          }}
          initialDate={newDate}
          initialDuration={newDuration}
          initialHour={newHour}
          appointments={appointments}
          blockedHours={businessHours.blockedHours}
        />
      )}
    </div>
  );
};

export default CalendarAppointments;
