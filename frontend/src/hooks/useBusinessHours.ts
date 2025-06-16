import { useState, useEffect, useCallback } from 'react';
import { format } from 'date-fns';
import api, { getDentistSchedule, saveDentistSchedule } from '../services/api';

export interface BlockedHour {
  date: string;
  start: string;
  end: string;
}

export interface BusinessHours {
  startTime: string;
  endTime: string;
  daysOfWeek: number[];
  blockedHours: BlockedHour[];
  workingDays: number[];
}

export function useBusinessHours() {
  const [businessHours, setBusinessHours] = useState<BusinessHours>({
    startTime: '08:00',
    endTime: '20:00',
    daysOfWeek: [0, 1, 2, 3, 4, 5, 6],
    blockedHours: [],
    workingDays: [1, 2, 3, 4, 5],
  });
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setLoading(true);
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
      setLoading(false);
    });
  }, []);

  // Actualizar horario de trabajo
  const updateBusinessHours = useCallback((updated: Partial<BusinessHours>) => {
    setBusinessHours(prev => {
      const merged = { ...prev, ...updated };
      saveDentistSchedule({
        startTime: merged.startTime,
        endTime: merged.endTime,
        workingDays: merged.workingDays,
        blockedHours: merged.blockedHours
      }).catch(console.error);
      return merged;
    });
  }, []);

  // Agregar horario bloqueado
  const addBlockedHour = useCallback((date: Date, start: string, end: string) => {
    if (!date || !start || !end) return;
    const dateStr = format(date, 'yyyy-MM-dd');
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
      }).catch(console.error);
      return updated;
    });
  }, []);

  // Eliminar horario bloqueado
  const removeBlockedHour = useCallback((index: number) => {
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
      }).catch(console.error);
      return updated;
    });
  }, []);

  // Cambiar días laborables
  const toggleWorkingDay = useCallback((day: number) => {
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
      }).catch(console.error);
      return updated;
    });
  }, []);

  // Verificar si un día está seleccionado
  const isDaySelected = useCallback((day: number) => {
    return businessHours.workingDays.includes(day);
  }, [businessHours.workingDays]);

  return {
    businessHours,
    setBusinessHours: updateBusinessHours,
    loading,
    addBlockedHour,
    removeBlockedHour,
    toggleWorkingDay,
    isDaySelected,
  };
} 