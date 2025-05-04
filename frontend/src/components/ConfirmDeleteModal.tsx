import React from 'react';

interface ConfirmDeleteModalProps {
  open: boolean;
  onClose: () => void;
  onConfirm: () => void;
  patientName?: string;
  appointmentDate?: string;
}

const ConfirmDeleteModal: React.FC<ConfirmDeleteModalProps> = ({ open, onClose, onConfirm, patientName, appointmentDate }) => {
  if (!open) return null;
  return (
    <div style={{
      position: 'fixed', top: 0, left: 0, width: '100vw', height: '100vh', background: 'rgba(0,0,0,0.35)', zIndex: 9999,
      display: 'flex', alignItems: 'center', justifyContent: 'center'
    }}>
      <div style={{ background: '#fff', borderRadius: 8, padding: 32, minWidth: 340, boxShadow: '0 4px 24px rgba(0,0,0,0.12)' }}>
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
          <svg width="48" height="48" fill="none" viewBox="0 0 24 24"><circle cx="12" cy="12" r="12" fill="#fdecea"/><path d="M12 8v4m0 4h.01" stroke="#d32f2f" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/></svg>
          <h2 style={{ color: '#d32f2f', margin: '16px 0 8px' }}>¿Seguro que deseas eliminar esta cita?</h2>
          {patientName && appointmentDate && (
            <div style={{ color: '#444', fontSize: 15, marginBottom: 16, textAlign: 'center' }}>
              Paciente: <b>{patientName}</b><br />
              Fecha: <b>{appointmentDate}</b>
            </div>
          )}
          <div style={{ display: 'flex', gap: 12, marginTop: 16 }}>
            <button onClick={onClose} style={{ padding: '8px 18px', borderRadius: 4, border: '1px solid #bbb', background: '#fff', color: '#333', fontWeight: 500, cursor: 'pointer' }}>Cancelar</button>
            <button onClick={onConfirm} style={{ padding: '8px 18px', borderRadius: 4, border: 'none', background: '#d32f2f', color: '#fff', fontWeight: 500, cursor: 'pointer' }}>Eliminar</button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ConfirmDeleteModal;
