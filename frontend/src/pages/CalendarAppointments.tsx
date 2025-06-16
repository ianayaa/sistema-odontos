import React, { useRef, useState, useEffect, useContext } from 'react';
import { toCDMXISOString } from '../utils/timezone';
import FullCalendar from '@fullcalendar/react';
import { DatesSetArg, EventClickArg, EventDropArg, EventInput } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import interactionPlugin from '@fullcalendar/interaction';
import esLocale from '@fullcalendar/core/locales/es';
import { Calendar, User, Phone, X, Check, WarningCircle, CalendarBlank, Clock } from 'phosphor-react';
import CalendarToolbar from '../components/calendar/CalendarToolbar';
import { Appointment, AppointmentStatus } from '../types/appointment';
import { Calendar as ModernCalendar, utils } from 'react-modern-calendar-datepicker';
import ModernDatePicker from '../components/ModernDatePicker';
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
import { message, Modal, ConfigProvider, TimePicker } from 'antd';
import dayjs from 'dayjs';
import esES from 'antd/lib/locale/es_ES';
import EditAppointmentModal from '../components/EditAppointmentModal';
import CalendarSidebar from '../components/calendar/CalendarSidebar';
import AppointmentDetailsModal from '../components/calendar/AppointmentDetailsModal';
import RescheduleNotifyModal from '../components/calendar/RescheduleNotifyModal';
import CalendarEventContent from '../components/calendar/CalendarEventContent';
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

let globalTooltip: HTMLDivElement | null = null;
let globalTooltipHideTimeout: NodeJS.Timeout | null = null;
let globalTooltipShowTimeout: NodeJS.Timeout | null = null;

function forceHideAppointmentTooltip(inmediato = false) {
  if (globalTooltipShowTimeout) clearTimeout(globalTooltipShowTimeout);
  if (globalTooltipHideTimeout) clearTimeout(globalTooltipHideTimeout);
  if (globalTooltip) {
    globalTooltip.style.opacity = '0';
    if (inmediato) {
      globalTooltip.remove();
      globalTooltip = null;
    } else {
      setTimeout(() => {
        if (globalTooltip) {
          globalTooltip.remove();
          globalTooltip = null;
        }
      }, 120);
    }
  }
}

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
  const [showEditModal, setShowEditModal] = useState(false);
  const [editAppointment, setEditAppointment] = useState<any>(null);
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
  const handleBusinessHoursChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
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
  };

  // Manejar días laborables
  const handleWorkingDaysChange = async (day: number) => {
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
        backgroundColor: bgColor,
        borderColor: 'transparent',
        textColor: textColor,
        extendedProps: appt,
        classNames: [
          style.border,
          style.text,
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
    forceHideAppointmentTooltip();
  };

  // Maneja la navegación a hoy
  const handleToday = () => {
    if (calendarRef.current) {
      calendarRef.current.getApi().today();
      setCurrentDate(new Date());
    }
    forceHideAppointmentTooltip();
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
    forceHideAppointmentTooltip();
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

    // Si la vista es de mes, permitir agendar sin validar traslape
    if (view === 'dayGridMonth') {
      // Extraer solo la fecha en formato YYYY-MM-DD
      const soloFecha = selectInfo.startStr.split('T')[0];
      setNewDate(soloFecha);
      setNewDuration(undefined);
      setNewHour(undefined);
      setShowModal(true);
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
  };

  // Estado para mostrar modal de confirmación de notificación
  const [notifyModal, setNotifyModal] = useState<{ visible: boolean; event?: any; newDate?: Date | null }>({ visible: false });

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
    // Guardar la nueva fecha en el estado para usarla al confirmar
    setNotifyModal({ visible: true, event: arg.event.extendedProps, newDate: start });
    forceHideAppointmentTooltip();
  };

  // Función para manejar la acción del modal de notificación
  const handleNotifyModal = async (shouldNotify: boolean) => {
    if (!notifyModal.event || !notifyModal.newDate) return;
    const arg = notifyModal.event;
    setNotifyModal({ visible: false });
    try {
      // Actualiza la cita en el backend con la nueva fecha

// ...
await api.put(`/appointments/${arg.id}`, {
        date: toCDMXISOString(notifyModal.newDate),
        enviarMensaje: shouldNotify
      });
      if (shouldNotify) {
        // Enviar notificación (ajusta la ruta según tu backend)
        await api.post(`/appointments/${arg.id}/notify`, { type: 'reschedule' });
        message.success('Notificación enviada.');
      } else {
        message.success('Cita re agendada sin notificación.');
      }
      setRefresh(r => !r);
    } catch (error) {
      console.error('Error al actualizar la cita o notificar:', error);
      // No revertir si solo fue error de notificación
      message.error('Error al actualizar o notificar.');
    }
  };

  // Renderiza el contenido de los eventos
  const renderEventContent = (eventInfo: { 
    event: { extendedProps: any },
    timeText: string,
    el?: HTMLElement
  }) => {
    const { extendedProps } = eventInfo.event;
    if (extendedProps.isBlocked) {
      return (
        <span className="text-xs font-semibold">Horario bloqueado</span>
      );
    }
    const appt = eventInfo.event.extendedProps as Appointment & { service?: { name?: string; color?: string } };
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

    // El nombre siempre se muestra en una sola línea con elipsis si es largo
    let nombreTruncado = nombreCompleto;

    // Detectar si el evento es "muy pequeño" (<= 20 minutos)
    let mostrarSoloNombre = false;
    if (appt.endDate) {
      const start = new Date(appt.date).getTime();
      const end = new Date(appt.endDate).getTime();
      const duracionMin = Math.round((end - start) / 60000);
      if (duracionMin <= 20) mostrarSoloNombre = true;
    } else if (appt.duration && appt.duration <= 20) {
      mostrarSoloNombre = true;
    }

    // Render: 1 línea por detalle (nombre, servicio, hora)
    return (
      <span
        style={{
          display: 'block',
          width: '100%',
          maxWidth: '100%',
          overflow: 'hidden',
          textOverflow: 'ellipsis',
          fontSize: 12,
          lineHeight: 1.2,
          whiteSpace: 'normal',
          wordBreak: 'break-word',
          maxHeight: mostrarSoloNombre ? 18 : 40,
        }}
        title={nombreCompleto + (appt.service?.name ? ' - ' + appt.service.name : '')}
      >
        {/* Nombre SIEMPRE en una sola línea con elipsis */}
        <span
          style={{
            fontWeight: 600,
            whiteSpace: 'nowrap',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            display: 'block',
            width: '100%',
            maxWidth: '100%',
          }}
        >
          {nombreTruncado}
        </span>
        {/* Si NO es muy pequeño, muestra servicio y hora, cada uno en su línea */}
        {!mostrarSoloNombre && (
          <>
            {appt.service?.name && (
              <span
                style={{
                  display: 'block',
                  whiteSpace: 'nowrap',
                  overflow: 'hidden',
                  textOverflow: 'ellipsis',
                  width: '100%',
                  maxWidth: '100%',
                  fontWeight: 400,
                }}
                title={appt.service.name}
              >
                {appt.service.name}
              </span>
            )}
            <span
              style={{
                display: 'block',
                whiteSpace: 'nowrap',
                overflow: 'hidden',
                textOverflow: 'ellipsis',
                width: '100%',
                maxWidth: '100%',
                fontWeight: 400,
              }}
              title={horaInicio + (horaFin ? ` - ${horaFin}` : '')}
            >
              {horaInicio} {horaFin && `- ${horaFin}`}
            </span>
          </>
        )}
      </span>
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
  }, [user, refresh, getDentistSchedule]);

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
      } catch (e) {
        console.error('Error al actualizar el tamaño del calendario:', e);
      }
    });
    observer.observe(calendarContainerRef.current);
    return () => {
      observer.disconnect();
    };
  }, [calendarRef]);

  // Maneja el evento de montaje de eventos
  const handleEventDidMount = (info: any) => {
    // Forzar color solo en la vista de mes
    if (
      info.view &&
      info.view.type === 'dayGridMonth' &&
      info.event.extendedProps &&
      info.event.extendedProps.service &&
      info.event.extendedProps.service.color
    ) {
      const bgColor = info.event.extendedProps.service.color;
      info.el.style.backgroundColor = bgColor;
      // Calcular color de texto adecuado
      let textColor = '#fff';
      if (bgColor.startsWith('#')) {
        const hex = bgColor.replace('#', '');
        const r = parseInt(hex.substring(0, 2), 16);
        const g = parseInt(hex.substring(2, 4), 16);
        const b = parseInt(hex.substring(4, 6), 16);
        const luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
        textColor = luminance > 0.6 ? '#222' : '#fff';
      }
      info.el.style.color = textColor;
    }

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

    const showTooltip = (e: MouseEvent) => {
      // Oculta cualquier tooltip anterior antes de mostrar uno nuevo, de inmediato
      forceHideAppointmentTooltip(true);
      if (globalTooltipHideTimeout) clearTimeout(globalTooltipHideTimeout);
      if (!globalTooltip) {
        globalTooltip = document.createElement('div');
        globalTooltip.innerHTML = `
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
        globalTooltip.style.position = 'absolute';
        globalTooltip.style.zIndex = '9999';
        globalTooltip.style.pointerEvents = 'none';
        globalTooltip.style.opacity = '0';
        document.body.appendChild(globalTooltip);
      }
      const rect = (e.target as HTMLElement).getBoundingClientRect();
      globalTooltip.style.top = `${rect.bottom + window.scrollY + 8}px`;
      globalTooltip.style.left = `${rect.left + window.scrollX}px`;
      globalTooltipShowTimeout = setTimeout(() => {
        if (globalTooltip) globalTooltip.style.opacity = '1';
      }, 60);
    };
    const hideTooltip = () => {
      if (globalTooltipShowTimeout) clearTimeout(globalTooltipShowTimeout);
      if (globalTooltip) {
        globalTooltip.style.opacity = '0';
        globalTooltipHideTimeout = setTimeout(() => {
          if (globalTooltip) {
            globalTooltip.remove();
            globalTooltip = null;
          }
        }, 120);
      }
    };
    info.el.addEventListener('mouseenter', showTooltip);
    info.el.addEventListener('mousemove', showTooltip);
    info.el.addEventListener('mouseleave', hideTooltip);
    info.el.addEventListener('mousedown', hideTooltip);
    info.el.addEventListener('click', hideTooltip);
  };

  // Llama a forceHideAppointmentTooltip en los siguientes lugares clave
  const handleShowModal = (show: boolean) => {
    if (!show) forceHideAppointmentTooltip();
  };

  const handleNotifyModalVisible = (visible: boolean) => {
    if (!visible) forceHideAppointmentTooltip();
  };

  const handleModalInfo = (info: any) => {
    if (!info) forceHideAppointmentTooltip();
  };

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
        <CalendarSidebar
          businessHours={businessHours}
          setBusinessHours={setBusinessHours}
          blockModal={blockModal}
          setBlockModal={setBlockModal}
          handleAddBlockedHour={handleAddBlockedHour}
          handleRemoveBlockedHour={handleRemoveBlockedHour}
          handleWorkingDaysChange={handleWorkingDaysChange}
          isDaySelected={isDaySelected}
          currentDate={currentDate}
          setCurrentDate={setCurrentDate}
          statusStyles={statusStyles}
          calendarRef={calendarRef}
        />
      )}

      {/* Calendario grande */}
      <div ref={calendarContainerRef} className="flex-1 bg-white rounded-xl shadow-sm overflow-hidden h-full">
        <CalendarToolbar
          view={view}
          onViewChange={handleViewChange}
          onNavigate={handleNavigate}
          onToday={handleToday}
          title={formatDateTitle()}
        />

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
            const bloqueosFecha = businessHours.blockedHours.filter(b => b.date === dateStr);

            // Si estás en la vista de mes, solo bloquea si el día está completamente bloqueado
            if (view === 'dayGridMonth') {
              // Si hay al menos un bloqueo en ese día, no permitir seleccionar
              return bloqueosFecha.length === 0;
            }

            // En otras vistas, usa la lógica de traslape por hora
            const horaInicio = start.getHours() * 60 + start.getMinutes();
            const horaFin = end.getHours() * 60 + end.getMinutes();
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
          eventContent={(eventInfo) => <CalendarEventContent {...eventInfo} />}
          eventDidMount={handleEventDidMount}
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
          moreLinkText={(n) => `+${n} más`}
          moreLinkClick="popover"
          eventMaxStack={2}
          eventOrder="start,-duration,title"
          eventDragStart={() => forceHideAppointmentTooltip()}
          eventDragStop={() => forceHideAppointmentTooltip()}
          key={`${calendarKey}-${isCollapsed}`}
        />
      </div>

      {/* Modal de detalles de cita */}
      <AppointmentDetailsModal
        visible={!!modalInfo}
        appointment={modalInfo}
        onClose={() => setModalInfo(null)}
        onDelete={async () => {
          await api.delete(`/appointments/${modalInfo.id}`);
          setModalInfo(null);
          setRefresh(r => !r);
        }}
        onCancel={async () => {
          await api.put(`/appointments/${modalInfo.id}`, { ...modalInfo, status: 'cancelada' });
          setModalInfo(null);
          setRefresh(r => !r);
        }}
        onReschedule={() => {
          setEditAppointment(modalInfo);
          setShowEditModal(true);
        }}
      />

      {/* Modal personalizado para notificación de re-agenda */}
      <RescheduleNotifyModal
        visible={notifyModal.visible}
        event={notifyModal.event}
        newDate={notifyModal.newDate}
        onNotify={handleNotifyModal}
        onClose={() => setNotifyModal({ visible: false, event: null })}
      />
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
      {showEditModal && editAppointment && (
        <EditAppointmentModal
          onClose={() => {
            setShowEditModal(false);
            setEditAppointment(null);
          }}
          onSuccess={() => {
            setShowEditModal(false);
            setEditAppointment(null);
            setModalInfo(null);
            setRefresh(r => !r);
          }}
          appointment={editAppointment}
          appointments={appointments}
          blockedHours={businessHours.blockedHours}
        />
      )}
    </div>
  );
};

export default CalendarAppointments;
