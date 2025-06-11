import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import timezone from 'dayjs/plugin/timezone';

dayjs.extend(utc);
dayjs.extend(timezone);

export function toCDMXISOString(date: Date | string) {
  // Convierte cualquier fecha a ISO string en zona horaria de CDMX
  return dayjs(date).tz('America/Mexico_City').toISOString();
}
