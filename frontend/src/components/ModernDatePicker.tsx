import React from 'react';
import { DatePicker as AntdDatePicker, ConfigProvider } from 'antd';
import esES from 'antd/locale/es_ES';
import 'antd/dist/reset.css';
import dayjs, { Dayjs } from 'dayjs';

interface Props {
  value: Date | null;
  onChange: (date: Date | null) => void;
  label?: string;
}

const ModernDatePicker: React.FC<Props> = ({ value, onChange, label }) => {
  return (
    <ConfigProvider locale={esES}>
      {label && <div className="text-xs text-gray-600 mb-1 font-semibold">{label}</div>}
      <AntdDatePicker
        value={value ? dayjs(value) : null}
        onChange={(date) => {
          if (date) {
            onChange(date.toDate());
          } else {
            onChange(null);
          }
        }}
        format="DD/MM/YYYY"
        allowClear
        className="w-full !rounded-xl !py-2 !px-3 !border-gray-200 focus:!border-red-400 focus:!ring-2 focus:!ring-red-100 bg-white text-gray-700 shadow-sm hover:!border-red-300"
        placeholder="Selecciona fecha"
        popupClassName="z-[1100]"
        style={{ width: '100%' }}
      />
    </ConfigProvider>
  );
};

export default ModernDatePicker;
