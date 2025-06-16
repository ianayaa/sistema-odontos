import React from 'react';

interface CalendarEventContentProps {
  event: { extendedProps: any };
  timeText: string;
}

const CalendarEventContent: React.FC<CalendarEventContentProps> = ({ event, timeText }) => {
  const { extendedProps } = event;
  if (extendedProps.isBlocked) {
    return <span className="text-xs font-semibold">Horario bloqueado</span>;
  }
  const appt = extendedProps as any & { service?: { name?: string; color?: string } };
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

export default CalendarEventContent; 