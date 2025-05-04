import React from 'react';
import { CalendarBlank } from 'phosphor-react';

interface DatePickerProps {
  value: string;
  onChange: (date: string) => void;
  disabled?: boolean;
}

const DatePicker: React.FC<DatePickerProps> = ({ value, onChange, disabled }) => {
  return (
    <div className="relative">
      <span className="absolute left-3 top-1/2 -translate-y-1/2 text-red-300 pointer-events-none">
        <CalendarBlank size={20} weight="duotone" />
      </span>
      <input
        type="datetime-local"
        value={value}
        onChange={e => onChange(e.target.value)}
        disabled={disabled}
        className="w-full border-gray-200 rounded-xl pl-10 pr-3 py-2 focus:border-red-400 focus:ring-2 focus:ring-red-100 bg-white text-gray-700 cursor-pointer transition-all shadow-sm hover:border-red-300 appearance-none"
      />
    </div>
  );
};

export default DatePicker;
