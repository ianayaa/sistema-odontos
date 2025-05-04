export type AppointmentStatus = 'confirmada' | 'cancelada' | 'pendiente' | 'reagendada';

export interface Patient {
  id: string;
  name: string;
  lastNamePaterno?: string;
  lastNameMaterno?: string;
  phone?: string;
}

export interface Appointment {
  id: string;
  date: string;
  status: AppointmentStatus;
  notes?: string;
  patient: Patient;
  treatment?: string;
  doctor?: string;
  duration?: number;
  endDate?: string;
} 