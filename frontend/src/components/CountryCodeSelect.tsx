import React from 'react';

const countryCodes = [
  { code: '+52', country: 'México' },
  { code: '+1', country: 'EEUU/Canadá' },
  { code: '+34', country: 'España' },
  { code: '+57', country: 'Colombia' },
  { code: '+51', country: 'Perú' },
  { code: '+54', country: 'Argentina' },
  { code: '+56', country: 'Chile' },
  { code: '+593', country: 'Ecuador' },
  { code: '+502', country: 'Guatemala' },
  // Agrega más países según necesidad
];

interface Props {
  value: string;
  onChange: (value: string) => void;
}

const CountryCodeSelect: React.FC<Props> = ({ value, onChange }) => (
  <select
    className="border border-gray-300 rounded-lg px-2 py-2 bg-gray-50 focus:outline-none focus:ring-2 focus:ring-red-500 text-sm"
    value={value}
    onChange={e => onChange(e.target.value)}
    required
  >
    <option value="">Lada</option>
    {countryCodes.map(opt => (
      <option key={opt.code} value={opt.code}>{opt.country} ({opt.code})</option>
    ))}
  </select>
);

export default CountryCodeSelect;
