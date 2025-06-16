// Utilidades para el calendario de citas

export function getContrastTextColor(bgColor: string) {
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

// Verifica si un horario está bloqueado para una fecha dada
export function isTimeBlocked(date: Date, blockedHours: { date: string; start: string; end: string }[]): boolean {
  const dateStr = typeof date === 'string' ? date : date.toISOString().slice(0, 10);
  const horaActual = date.getHours() * 60 + date.getMinutes();
  const bloqueosFecha = blockedHours.filter(b => b.date === dateStr);
  return bloqueosFecha.some(b => {
    const [hStart, mStart] = b.start.split(":").map(Number);
    const [hEnd, mEnd] = b.end.split(":").map(Number);
    const minStart = hStart * 60 + mStart;
    const minEnd = hEnd * 60 + mEnd;
    return horaActual >= minStart && horaActual < minEnd;
  });
}

// Verifica si hay traslape de citas
export function hasAppointmentOverlap(start: Date, end: Date, appointments: { date: string; endDate?: string; duration?: number }[]): boolean {
  return appointments.some(appt => {
    const apptStart = new Date(appt.date);
    const apptEnd = appt.endDate ? new Date(appt.endDate) : new Date(apptStart.getTime() + (appt.duration || 60) * 60000);
    return start < apptEnd && end > apptStart;
  });
}

/**
 * Determina si un slot es seleccionable según bloqueos y vista.
 * @param start Fecha/hora de inicio del slot
 * @param end Fecha/hora de fin del slot
 * @param blockedHours Lista de bloqueos
 * @param view Vista actual del calendario ("dayGridMonth" u otra)
 */
export function isSlotSelectable(start: Date, end: Date, blockedHours: { date: string; start: string; end: string }[], view: string): boolean {
  const dateStr = start.toISOString().slice(0, 10);
  const bloqueosFecha = blockedHours.filter(b => b.date === dateStr);
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
} 