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
import DaySelect, { dayOptions } from '../components/calendar/DaySelect';
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
import { getContrastTextColor, isTimeBlocked, hasAppointmentOverlap, isSlotSelectable, formatDateTitle } from '../components/calendar/calendarUtils';
import { useAppointments } from '../hooks/useAppointments';
import { useBusinessHours, BusinessHours } from '../hooks/useBusinessHours';
import { useAppointmentTooltip } from '../hooks/useAppointmentTooltip';
import { useCalendarModals } from '../hooks/useCalendarModals';
registerLocale('es', es);

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
  const [view, setView] = useState<'timeGridWeek' | 'timeGridDay' | 'dayGridMonth'>(() => {
    return (localStorage.getItem('calendarView') as 'timeGridWeek' | 'timeGridDay' | 'dayGridMonth') || 'timeGridWeek';
  });
  const [currentDate, setCurrentDate] = useState(() => new Date());
  const { user } = useAuth();
  const { appointments, loading: loadingAppointments, reload: reloadAppointments } = useAppointments(user);
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const [calendarKey, setCalendarKey] = useState(0);
  const { isCollapsed } = useContext(SidebarCollapsedContext);
  const {
    businessHours,
    setBusinessHours: updateBusinessHours,
    loading: loadingBusinessHours,
    addBlockedHour,
    removeBlockedHour,
    toggleWorkingDay,
    isDaySelected,
  } = useBusinessHours();
  const { showTooltip, hideTooltip, forceHideAppointmentTooltip } = useAppointmentTooltip();
  const modals = useCalendarModals();

  /**
   * Maneja el cambio de horarios de trabajo
   */
  const handleBusinessHoursChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    const updated = { ...businessHours, [name]: value };
    updateBusinessHours(updated);
    saveDentistSchedule({
      startTime: updated.startTime,
      endTime: updated.endTime,
      workingDays: updated.workingDays,
      blockedHours: updated.blockedHours
    }).catch(error => {
      console.error('Error al guardar horario:', error);
      message.error('Error al guardar el horario. Por favor intenta nuevamente.');
    });
    setCalendarKey(k => k + 1);
  };

  /**
   * Maneja el click en una cita para mostrar detalles
   */
  const handleEventClick = (arg: EventClickArg) => {
    const cita = arg.event.extendedProps as Appointment;
    modals.openDetailsModal(cita);
  };

  /**
   * Maneja el drag & drop de eventos (citas)
   */
  const handleEventDrop = async (arg: EventDropArg) => {
    const start = arg.event.start;
    if (!start) return;
    if (isTimeBlocked(start, businessHours.blockedHours)) {
      message.warning("No se puede mover la cita a un horario bloqueado para esa fecha.");
      arg.revert();
      return;
    }
    modals.openNotifyModal(arg.event.extendedProps as Appointment, start);
    forceHideAppointmentTooltip();
  };

  /**
   * Maneja la selección de slots en el calendario
   */
  const handleSelect = (selectInfo: any) => {
    const start = new Date(selectInfo.startStr);
    const end = new Date(selectInfo.endStr);
    const day = start.getDay();
    if (!businessHours.workingDays.includes(day)) {
      message.warning('Este día no está disponible para agendar citas. Por favor selecciona un día laborable.');
      return;
    }
    if (view === 'dayGridMonth') {
      const soloFecha = selectInfo.startStr.split('T')[0];
      modals.openAddModal(soloFecha);
      return;
    }
    if (hasAppointmentOverlap(start, end, appointments)) {
      message.warning('Ya existe una cita en ese horario.');
      return;
    }
    if (isTimeBlocked(start, businessHours.blockedHours)) {
      message.warning('No se puede agendar en un horario bloqueado para esa fecha.');
      return;
    }
    modals.openAddModal(
      format(start, 'yyyy-MM-dd'),
      Math.round((end.getTime() - start.getTime()) / 60000),
      start.toTimeString().slice(0, 5)
    );
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

    const tooltipContent = `
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

    info.el.addEventListener('mouseenter', (e: MouseEvent) => showTooltip(e, tooltipContent));
    info.el.addEventListener('mousemove', (e: MouseEvent) => showTooltip(e, tooltipContent));
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

  /**
   * Maneja la acción del modal de notificación de reagendado
   */
  const handleNotifyModal = async (shouldNotify: boolean) => {
    if (!modals.notifyModal.event || !modals.notifyModal.newDate) return;
    const arg = modals.notifyModal.event;
    modals.closeNotifyModal();
    try {
      await api.put(`/appointments/${arg.id}`, {
        date: toCDMXISOString(modals.notifyModal.newDate),
        enviarMensaje: shouldNotify
      });
      if (shouldNotify) {
        await api.post(`/appointments/${arg.id}/notify`, { type: 'reschedule' });
        message.success('Notificación enviada.');
      } else {
        message.success('Cita re agendada sin notificación.');
      }
      reloadAppointments();
    } catch (error) {
      console.error('Error al actualizar la cita o notificar:', error);
      message.error('Error al actualizar o notificar.');
    }
  };

  // Definir statusStyles antes del return:
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

  // Definir events antes del return:
  const events: EventInput[] = [
    ...appointments.map(apptRaw => {
      const appt = apptRaw as Appointment & { service?: { color?: string } };
      const style = statusStyles[appt.status] || statusStyles.pendiente;
      let end;
      if (appt.endDate) {
        end = appt.endDate;
      } else if (appt.duration) {
        end = new Date(new Date(appt.date).getTime() + appt.duration * 60000);
      } else {
        end = new Date(new Date(appt.date).getTime() + 30 * 60000);
      }
      const bgColor = appt.service?.color || '#f3f4f6';
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

  // Definir funciones antes del return:
  const handleViewChange = (newView: 'timeGridWeek' | 'timeGridDay' | 'dayGridMonth') => {
    setView(newView);
    localStorage.setItem('calendarView', newView);
    if (calendarRef.current) {
      calendarRef.current.getApi().changeView(newView);
    }
    forceHideAppointmentTooltip();
  };
  const handleToday = () => {
    if (calendarRef.current) {
      calendarRef.current.getApi().today();
      setCurrentDate(new Date());
    }
    forceHideAppointmentTooltip();
  };
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

  // Ahora el return principal:
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
          blockModal={modals.blockModal}
          setBlockModal={modals.setBlockModal}
          addBlockedHour={(date, start, end) => {
            // Validaciones locales antes de llamar al hook
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
            addBlockedHour(date, start, end);
            modals.setBlockModal({ show: false, date: null, start: '', end: '' });
          }}
          removeBlockedHour={removeBlockedHour}
          toggleWorkingDay={toggleWorkingDay}
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
          title={formatDateTitle(view, currentDate)}
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
            return isSlotSelectable(selectInfo.start, selectInfo.end, businessHours.blockedHours, view);
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

      {/* Modales */}
      <AppointmentDetailsModal
        visible={!!modals.modalInfo}
        appointment={modals.modalInfo ?? undefined}
        onClose={modals.closeDetailsModal}
        onDelete={async () => {
          if (!modals.modalInfo) return;
          await api.delete(`/appointments/${modals.modalInfo.id}`);
          modals.closeDetailsModal();
          reloadAppointments();
        }}
        onCancel={async () => {
          if (!modals.modalInfo) return;
          await api.put(`/appointments/${modals.modalInfo.id}`, { ...modals.modalInfo, status: 'cancelada' });
          modals.closeDetailsModal();
          reloadAppointments();
        }}
        onReschedule={() => {
          if (!modals.modalInfo) return;
          modals.openEditModal(modals.modalInfo);
        }}
      />
      <RescheduleNotifyModal
        visible={modals.notifyModal.visible}
        event={modals.notifyModal.event}
        newDate={modals.notifyModal.newDate}
        onNotify={handleNotifyModal}
        onClose={modals.closeNotifyModal}
      />
      {modals.showModal && (
        <AddAppointmentModal
          onClose={modals.closeAddModal}
          onSuccess={() => {
            modals.closeAddModal();
            reloadAppointments();
          }}
          initialDate={modals.newDate}
          initialDuration={modals.newDuration}
          initialHour={modals.newHour}
          appointments={appointments}
          blockedHours={businessHours.blockedHours}
        />
      )}
      {modals.showEditModal && modals.editAppointment && (
        <EditAppointmentModal
          onClose={modals.closeEditModal}
          onSuccess={() => {
            modals.closeEditModal();
            modals.closeDetailsModal();
            reloadAppointments();
          }}
          appointment={modals.editAppointment ?? undefined}
          appointments={appointments}
          blockedHours={businessHours.blockedHours}
        />
      )}
    </div>
  );
};

export default CalendarAppointments;