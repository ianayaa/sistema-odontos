import React from 'react';
import { Clock, X } from 'phosphor-react';
import DatePicker from 'react-datepicker';
import { format } from 'date-fns';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { DateCalendar, PickersDay } from '@mui/x-date-pickers';
import { es } from 'date-fns/locale';
import ModernDatePicker from '../ModernDatePicker';
import { ConfigProvider, TimePicker, message } from 'antd';
import esES from 'antd/lib/locale/es_ES';

// Tipos para las props
interface BlockedHour {
  date: string;
  start: string;
  end: string;
}

interface BusinessHours {
  startTime: string;
  endTime: string;
  daysOfWeek: number[];
  blockedHours: BlockedHour[];
  workingDays: number[];
}

interface BlockModalState {
  show: boolean;
  date: Date | null;
  start: string;
  end: string;
}

interface StatusStyle {
  bg: string;
  border: string;
  text: string;
  icon: JSX.Element;
}

interface CalendarSidebarProps {
  businessHours: BusinessHours;
  setBusinessHours: React.Dispatch<React.SetStateAction<BusinessHours>>;
  blockModal: BlockModalState;
  setBlockModal: React.Dispatch<React.SetStateAction<BlockModalState>>;
  handleAddBlockedHour: (date: Date, start: string, end: string) => void;
  handleRemoveBlockedHour: (index: number) => void;
  handleWorkingDaysChange: (day: number) => void;
  isDaySelected: (day: number) => boolean;
  currentDate: Date;
  setCurrentDate: (date: Date) => void;
  statusStyles: Record<string, StatusStyle>;
  calendarRef: React.RefObject<any>;
}

const CalendarSidebar: React.FC<CalendarSidebarProps> = ({
  businessHours,
  setBusinessHours,
  blockModal,
  setBlockModal,
  handleAddBlockedHour,
  handleRemoveBlockedHour,
  handleWorkingDaysChange,
  isDaySelected,
  currentDate,
  setCurrentDate,
  statusStyles,
  calendarRef,
}) => {
  return (
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
                if (calendarRef.current) {
                  calendarRef.current.getApi().changeView('timeGridDay', date);
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
              '& .MuiDayCalendar-weekContainer': {
                justifyContent: 'flex-start',
                display: 'flex',
              },
            }}
            dayOfWeekFormatter={(date) => {
              const label = date.toLocaleDateString('es-MX', { weekday: 'short' });
              return label.charAt(0).toUpperCase() + label.slice(1);
            }}
            // El resaltado de semana se puede personalizar aquí si se desea
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
                  setBusinessHours(prev => ({ ...prev, startTime: newTime }));
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
                  setBusinessHours(prev => ({ ...prev, endTime: newTime }));
                }}
                showTimeSelect
                showTimeSelectOnly
                timeIntervals={15}
                timeCaption="Hora"
                dateFormat="h:mm aa"
                className="w-full border-2 border-blue-200 rounded-xl px-3 py-2 bg-blue-50 text-gray-700"
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
            <div className="flex flex-col w-full">
              <ModernDatePicker
                value={blockModal.date}
                onChange={(date: Date | null) => setBlockModal(prev => ({ ...prev, date }))}
                label="Fecha"
              />
            </div>
            <div className="flex flex-col w-full">
              <label className="text-xs text-gray-600 mb-1">Hora inicio</label>
              <ConfigProvider locale={esES}>
                <TimePicker
                  value={blockModal.start ? require('dayjs')(`1970-01-01T${blockModal.start}:00`) : null}
                  onChange={time => setBlockModal(prev => ({ ...prev, start: time ? time.format('HH:mm') : '' }))}
                  format="HH:mm"
                  minuteStep={15}
                  className="w-full !rounded-xl !py-2 !px-3 !border-gray-200 focus:!border-red-400 focus:!ring-2 focus:!ring-red-100 bg-white text-gray-700 shadow-sm hover:!border-red-300"
                  placeholder="Selecciona hora"
                  popupClassName="z-[1100]"
                  style={{ width: '100%' }}
                />
              </ConfigProvider>
            </div>
            <span className="text-center text-gray-400 text-xs">a</span>
            <div className="flex flex-col w-full">
              <label className="text-xs text-gray-600 mb-1">Hora fin</label>
              <ConfigProvider locale={esES}>
                <TimePicker
                  value={blockModal.end ? require('dayjs')(`1970-01-01T${blockModal.end}:00`) : null}
                  onChange={time => setBlockModal(prev => ({ ...prev, end: time ? time.format('HH:mm') : '' }))}
                  format="HH:mm"
                  minuteStep={15}
                  className="w-full !rounded-xl !py-2 !px-3 !border-gray-200 focus:!border-red-400 focus:!ring-2 focus:!ring-red-100 bg-white text-gray-700 shadow-sm hover:!border-red-300"
                  placeholder="Selecciona hora"
                  popupClassName="z-[1100]"
                  style={{ width: '100%' }}
                />
              </ConfigProvider>
            </div>
            <button
              type="submit"
              className="w-full mt-2 bg-gradient-to-r from-yellow-400 to-yellow-300 hover:from-yellow-500 hover:to-yellow-400 text-yellow-900 font-bold py-2 px-4 rounded-xl transition-all duration-200 shadow-md text-base"
            >
              Bloquear horario
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
  );
};

export default CalendarSidebar; 