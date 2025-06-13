import React from 'react';
import { CalendarBlank, Clock } from 'phosphor-react';

type CalendarView = 'timeGridWeek' | 'timeGridDay' | 'dayGridMonth';

interface CalendarToolbarProps {
  view: CalendarView;
  onViewChange: (view: CalendarView) => void;
  onNavigate: (direction: 'prev' | 'next') => void;
  onToday: () => void;
  title: string;
}

const CalendarToolbar: React.FC<CalendarToolbarProps> = ({
  view,
  onViewChange,
  onNavigate,
  onToday,
  title,
}) => {
  return (
    <div className="p-4 border-b border-gray-200 bg-fef2f2 shadow-md rounded-t-xl">
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div className="flex items-center gap-2">
          <button
            onClick={() => onNavigate('prev')}
            className="p-2 rounded-full text-red-500 bg-white border border-red-100 shadow hover:bg-red-50 hover:scale-110 transition-all"
            title="Anterior"
            aria-label="Semana anterior"
          >
            <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
              <path fillRule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clipRule="evenodd" />
            </svg>
          </button>
          <h2 className="text-xl font-extrabold text-gray-800 min-w-[200px] text-center drop-shadow-sm tracking-tight">
            {title}
          </h2>
          <button
            onClick={() => onNavigate('next')}
            className="p-2 rounded-full text-red-500 bg-white border border-red-100 shadow hover:bg-red-50 hover:scale-110 transition-all"
            title="Siguiente"
            aria-label="Siguiente semana"
          >
            <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
              <path fillRule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clipRule="evenodd" />
            </svg>
          </button>
        </div>
        
        <div className="flex items-center gap-2 bg-white/70 px-2 py-1 rounded-xl shadow-sm border border-gray-100">
          <button
            onClick={() => onViewChange('dayGridMonth')}
            className={`px-3 py-1 rounded-lg text-sm font-bold flex items-center gap-1 transition-all ${
              view === 'dayGridMonth' 
                ? 'bg-red-200 text-red-700 shadow' 
                : 'bg-gray-100 text-gray-600 hover:bg-red-50 hover:text-red-700'
            }`}
            title="Vista mensual"
            aria-pressed={view === 'dayGridMonth'}
          >
            <CalendarBlank className="inline-block" size={18} /> Mes
          </button>
          <button
            onClick={() => onViewChange('timeGridWeek')}
            className={`px-3 py-1 rounded-lg text-sm font-bold flex items-center gap-1 transition-all ${
              view === 'timeGridWeek' 
                ? 'bg-red-200 text-red-700 shadow' 
                : 'bg-gray-100 text-gray-600 hover:bg-red-50 hover:text-red-700'
            }`}
            title="Vista semanal"
            aria-pressed={view === 'timeGridWeek'}
          >
            <Clock className="inline-block" size={18} /> Semana
          </button>
          <button
            onClick={() => onViewChange('timeGridDay')}
            className={`px-3 py-1 rounded-lg text-sm font-bold flex items-center gap-1 transition-all ${
              view === 'timeGridDay' 
                ? 'bg-red-200 text-red-700 shadow' 
                : 'bg-gray-100 text-gray-600 hover:bg-red-50 hover:text-red-700'
            }`}
            title="Vista diaria"
            aria-pressed={view === 'timeGridDay'}
          >
            <CalendarBlank className="inline-block" size={18} /> Día
          </button>
        </div>
        
        <div className="flex items-center gap-2">
          <button
            onClick={onToday}
            className="px-4 py-2 rounded-lg bg-red-500 text-white text-sm font-bold shadow hover:bg-red-600 transition-all"
            title="Ir a hoy"
          >
            Hoy
          </button>
        </div>
      </div>
    </div>
  );
};

export default CalendarToolbar;
