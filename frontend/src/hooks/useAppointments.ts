import { useState, useEffect, useCallback } from 'react';
import api from '../services/api';
import { Appointment } from '../types/appointment';

export function useAppointments(user: any) {
  const [appointments, setAppointments] = useState<Appointment[]>([]);
  const [loading, setLoading] = useState(false);
  const [refresh, setRefresh] = useState(false);

  const reload = useCallback(() => setRefresh(r => !r), []);

  useEffect(() => {
    if (!user) return;
    setLoading(true);
    let url = '/appointments';
    if (user.role === 'DENTIST') {
      url += `?dentistId=${user.id}`;
    }
    api.get(url)
      .then(res => setAppointments(res.data))
      .finally(() => setLoading(false));
  }, [user, refresh]);

  return { appointments, loading, reload };
} 