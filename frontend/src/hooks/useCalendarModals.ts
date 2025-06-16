import { useState } from 'react';
import { Appointment } from '../types/appointment';

export interface NotifyModalState {
  visible: boolean;
  event?: Appointment | null;
  newDate?: Date | null;
}

export interface BlockModalState {
  show: boolean;
  date: Date | null;
  start: string;
  end: string;
}

export function useCalendarModals() {
  const [showModal, setShowModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [modalInfo, setModalInfo] = useState<Appointment | null>(null);
  const [editAppointment, setEditAppointment] = useState<Appointment | null>(null);
  const [notifyModal, setNotifyModal] = useState<NotifyModalState>({ visible: false });
  const [blockModal, setBlockModal] = useState<BlockModalState>({ show: false, date: null, start: '', end: '' });
  const [newDate, setNewDate] = useState<string | null>(null);
  const [newDuration, setNewDuration] = useState<number | undefined>(undefined);
  const [newHour, setNewHour] = useState<string | undefined>(undefined);

  // Handlers para abrir/cerrar modales
  const openAddModal = (date?: string, duration?: number, hour?: string) => {
    setNewDate(date || null);
    setNewDuration(duration);
    setNewHour(hour);
    setShowModal(true);
  };
  const closeAddModal = () => setShowModal(false);

  const openEditModal = (appt: Appointment) => {
    setEditAppointment(appt);
    setShowEditModal(true);
  };
  const closeEditModal = () => {
    setEditAppointment(null);
    setShowEditModal(false);
  };

  const openDetailsModal = (appt: Appointment) => setModalInfo(appt);
  const closeDetailsModal = () => setModalInfo(null);

  const openNotifyModal = (event: Appointment, newDate: Date) => setNotifyModal({ visible: true, event, newDate });
  const closeNotifyModal = () => setNotifyModal({ visible: false });

  const openBlockModal = (date: Date | null = null, start = '', end = '') => setBlockModal({ show: true, date, start, end });
  const closeBlockModal = () => setBlockModal({ show: false, date: null, start: '', end: '' });

  return {
    // Estados
    showModal,
    showEditModal,
    modalInfo,
    editAppointment,
    notifyModal,
    blockModal,
    newDate,
    newDuration,
    newHour,
    // Handlers
    openAddModal,
    closeAddModal,
    openEditModal,
    closeEditModal,
    openDetailsModal,
    closeDetailsModal,
    openNotifyModal,
    closeNotifyModal,
    openBlockModal,
    closeBlockModal,
    setNewDate,
    setNewDuration,
    setNewHour,
    setBlockModal,
    setNotifyModal,
    setEditAppointment,
    setModalInfo,
  };
} 