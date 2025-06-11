import React, { useEffect, useState } from 'react';
import { X, CheckCircle, WarningCircle } from 'phosphor-react';

type NotificationType = 'success' | 'error';

interface NotificationProps {
  message: string;
  type: NotificationType;
  onClose: () => void;
}

const Notification: React.FC<NotificationProps> = ({
  message,
  type,
  onClose,
}) => {
  const [isVisible, setIsVisible] = useState(true);

  useEffect(() => {
    const timer = setTimeout(() => {
      handleClose();
    }, 5000);

    return () => clearTimeout(timer);
  }, []);

  const handleClose = () => {
    setIsVisible(false);
    setTimeout(onClose, 300);
  };

  if (!isVisible) return null;

  return (
    <div 
      className={`fixed top-6 right-6 z-50 p-4 rounded-lg shadow-lg border ${
        type === 'success' ? 'bg-green-50 border-green-200 text-green-800' : 'bg-red-50 border-red-200 text-red-800'
      }`}
      style={{ minWidth: '300px', maxWidth: '400px' }}
    >
      <div className="flex items-start">
        <div className="flex-shrink-0 mr-3">
          {type === 'success' ? (
            <CheckCircle size={24} weight="fill" className="text-green-500" />
          ) : (
            <WarningCircle size={24} weight="fill" className="text-red-500" />
          )}
        </div>
        <div className="flex-1">
          <p className="text-sm font-medium">
            {type === 'success' ? '¡Éxito!' : 'Error'}
          </p>
          <p className="text-sm mt-1">{message}</p>
        </div>
        <button
          onClick={handleClose}
          className="ml-4 text-gray-400 hover:text-gray-500 focus:outline-none"
        >
          <X size={20} weight="bold" />
        </button>
      </div>
    </div>
  );
};

export default Notification;
