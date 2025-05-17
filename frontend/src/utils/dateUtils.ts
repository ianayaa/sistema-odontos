import { formatInTimeZone, toZonedTime } from 'date-fns-tz';

const TIMEZONE = 'America/Mexico_City';

export const formatDate = (date: Date | string) => {
  const dateObj = typeof date === 'string' ? new Date(date) : date;
  return formatInTimeZone(dateObj, TIMEZONE, 'dd/MM/yyyy');
};

export const formatTime = (date: Date | string) => {
  const dateObj = typeof date === 'string' ? new Date(date) : date;
  return formatInTimeZone(dateObj, TIMEZONE, 'HH:mm');
};

export const formatDateTime = (date: Date | string) => {
  const dateObj = typeof date === 'string' ? new Date(date) : date;
  return formatInTimeZone(dateObj, TIMEZONE, 'dd/MM/yyyy HH:mm');
};

export const toZonedDate = (date: Date | string) => {
  const dateObj = typeof date === 'string' ? new Date(date) : date;
  return toZonedTime(dateObj, TIMEZONE);
};

export const createDateWithTime = (date: Date | string, time: string) => {
  const dateObj = typeof date === 'string' ? new Date(date) : date;
  const [hours, minutes] = time.split(':').map(Number);
  const newDate = new Date(dateObj);
  newDate.setHours(hours, minutes, 0, 0);
  return toZonedDate(newDate);
}; 