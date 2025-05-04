import React, { useState, useEffect } from 'react';
import { Tooltip } from 'react-tooltip';

const permanentTeeth = [
  // Superior derecha 18-11
  18, 17, 16, 15, 14, 13, 12, 11,
  // Superior izquierda 21-28
  21, 22, 23, 24, 25, 26, 27, 28,
  // Inferior izquierda 38-31
  38, 37, 36, 35, 34, 33, 32, 31,
  // Inferior derecha 41-48
  41, 42, 43, 44, 45, 46, 47, 48
];

const primaryTeeth = [
  // Superior derecha 55-51
  55, 54, 53, 52, 51,
  // Superior izquierda 61-65
  61, 62, 63, 64, 65,
  // Inferior izquierda 75-71
  75, 74, 73, 72, 71,
  // Inferior derecha 81-85
  81, 82, 83, 84, 85
];

const toothStates = [
  { value: 'sano', label: 'Sano', color: '#4ade80' },
  { value: 'caries', label: 'Caries', color: '#f87171' },
  { value: 'ausente', label: 'Ausente', color: '#a3a3a3' },
  { value: 'obturacion', label: 'Obturación', color: '#60a5fa' },
  { value: 'endodoncia', label: 'Endodoncia', color: '#a78bfa' },
  { value: 'protesis', label: 'Prótesis', color: '#fde047' },
  { value: 'fractura', label: 'Fractura', color: '#fb923c' },
  { value: 'movilidad', label: 'Movilidad', color: '#f472b6' },
  { value: 'otro', label: 'Otro', color: '#000000' },
];

function getDefaultOdontogram() {
  const data: any = {};
  [...permanentTeeth, ...primaryTeeth].forEach(t => {
    data[t] = { state: '', note: '' };
  });
  return data;
}

const ToothSVG: React.FC<{
  label: string | number;
  state?: string;
  note?: string;
  selected?: boolean;
  onClick?: () => void;
}> = ({ label, state, note, selected, onClick }) => {
  const stateObj = toothStates.find(s => s.value === state);
  const fill = stateObj ? stateObj.color : '#fff';
  const stroke = selected ? '#e11d48' : '#d1d5db';
  return (
    <div data-tooltip-id={`tooth-${label}`}> 
      <svg
        width={54}
        height={64}
        viewBox="0 0 40 48"
        className={`cursor-pointer transition-all ${selected ? 'drop-shadow-lg' : ''}`}
        onClick={onClick}
        style={{ background: 'none' }}
      >
        <path
          d="M10 8 Q20 0 30 8 Q38 18 20 46 Q2 18 10 8 Z"
          fill={fill}
          stroke={stroke}
          strokeWidth={selected ? 3 : 2}
        />
        <text
          x="20"
          y="26"
          textAnchor="middle"
          fontSize="15"
          fontWeight="bold"
          fill={state === 'ausente' ? '#fff' : '#374151'}
          style={{ pointerEvents: 'none', userSelect: 'none' }}
        >
          {label}
        </text>
      </svg>
      <Tooltip id={`tooth-${label}`} place="top" style={{ zIndex: 9999 }}>
        <div className="text-xs">
          <div><b>Estado:</b> {stateObj ? stateObj.label : 'Sin estado'}</div>
          {note && <div><b>Nota:</b> {note}</div>}
        </div>
      </Tooltip>
    </div>
  );
};

const Odontogram: React.FC<{
  value?: any;
  onChange?: (data: any) => void;
}> = ({ value, onChange }) => {
  const [odontogram, setOdontogram] = useState<any>(getDefaultOdontogram());
  const [selectedTooth, setSelectedTooth] = useState<string | number | null>(null);

  useEffect(() => {
    if (value) {
      const updatedOdontogram = { ...getDefaultOdontogram() };
      Object.keys(value).forEach(key => {
        if (value[key] && typeof value[key] === 'object') {
          updatedOdontogram[key] = {
            state: value[key].state || '',
            note: value[key].note || ''
          };
        }
      });
      setOdontogram(updatedOdontogram);
    }
  }, [value]);

  const handleToothClick = (tooth: string | number) => {
    setSelectedTooth(tooth);
  };

  const handleStateChange = (state: string) => {
    if (!selectedTooth) return;
    const updated = {
      ...odontogram,
      [selectedTooth]: { 
        ...odontogram[selectedTooth], 
        state,
        note: odontogram[selectedTooth]?.note || ''
      }
    };
    setOdontogram(updated);
    onChange && onChange(updated);
  };

  const handleNoteChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    if (!selectedTooth) return;
    const updated = {
      ...odontogram,
      [selectedTooth]: { 
        ...odontogram[selectedTooth], 
        note: e.target.value,
        state: odontogram[selectedTooth]?.state || ''
      }
    };
    setOdontogram(updated);
    onChange && onChange(updated);
  };

  const closeModal = () => setSelectedTooth(null);

  const renderTooth = (tooth: string | number) => (
    <div key={tooth} className="flex flex-col items-center">
      <ToothSVG
        label={tooth}
        state={odontogram[tooth]?.state}
        note={odontogram[tooth]?.note}
        selected={selectedTooth === tooth}
        onClick={() => handleToothClick(tooth)}
      />
    </div>
  );

  return (
    <div>
      <h4 className="font-bold text-lg mb-2 text-red-700">Odontograma</h4>
      <div className="flex flex-col gap-8 items-center">
        <div className="mb-1 text-center font-semibold text-gray-600">Arcada Superior</div>
        <div className="flex gap-8">
          <div>
            <div className="mb-2 text-center font-semibold text-gray-600">Permanentes</div>
            <div className="grid grid-cols-8 gap-2 mb-4">
              {permanentTeeth.slice(0, 8).map(renderTooth)}
            </div>
            <div className="grid grid-cols-8 gap-2 mb-4">
              {permanentTeeth.slice(8, 16).map(renderTooth)}
            </div>
          </div>
          <div>
            <div className="mb-2 text-center font-semibold text-gray-600">Temporales</div>
            <div className="grid grid-cols-5 gap-2 mb-4">
              {primaryTeeth.slice(0, 5).map(renderTooth)}
            </div>
            <div className="grid grid-cols-5 gap-2 mb-4">
              {primaryTeeth.slice(5, 10).map(renderTooth)}
            </div>
          </div>
        </div>
        <div className="mb-1 text-center font-semibold text-gray-600">Arcada Inferior</div>
        <div className="flex gap-8">
          <div>
            <div className="mb-2 text-center font-semibold text-gray-600">Permanentes</div>
            <div className="grid grid-cols-8 gap-2 mb-4">
              {permanentTeeth.slice(16, 24).map(renderTooth)}
            </div>
            <div className="grid grid-cols-8 gap-2 mb-4">
              {permanentTeeth.slice(24, 32).map(renderTooth)}
            </div>
          </div>
          <div>
            <div className="mb-2 text-center font-semibold text-gray-600">Temporales</div>
            <div className="grid grid-cols-5 gap-2 mb-4">
              {primaryTeeth.slice(10, 15).map(renderTooth)}
            </div>
            <div className="grid grid-cols-5 gap-2 mb-4">
              {primaryTeeth.slice(15, 20).map(renderTooth)}
            </div>
          </div>
        </div>
      </div>
      {/* Leyenda de colores */}
      <div className="flex flex-wrap gap-2 justify-center mt-4 mb-2">
        {toothStates.map(s => (
          <div key={s.value} className="flex items-center gap-1">
            <span className="inline-block w-4 h-4 rounded-full border border-gray-300" style={{ background: s.color }}></span>
            <span className="text-xs text-gray-700">{s.label}</span>
          </div>
        ))}
      </div>
      {/* Modal para editar diente */}
      {selectedTooth && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40">
          <div className="bg-white rounded-xl shadow-xl p-6 w-full max-w-xs relative animate-fadeInUp">
            <button className="absolute top-2 right-2 text-gray-400 hover:text-red-600" onClick={closeModal}>&times;</button>
            <div className="font-bold text-lg mb-2 text-red-700">Diente {selectedTooth}</div>
            <div className="mb-2">
              <label className="block text-sm font-semibold mb-1">Estado</label>
              <div className="grid grid-cols-2 gap-2">
                {toothStates.map(s => (
                  <button
                    key={s.value}
                    className={`px-2 py-1 rounded font-semibold flex items-center gap-2 ${odontogram[selectedTooth]?.state === s.value ? 'ring-2 ring-red-500' : 'bg-gray-100'}`}
                    style={{ background: odontogram[selectedTooth]?.state === s.value ? s.color : undefined, color: s.value === 'otro' ? '#fff' : undefined }}
                    onClick={() => handleStateChange(s.value)}
                    type="button"
                  >
                    {s.label}
                  </button>
                ))}
              </div>
            </div>
            <div>
              <label className="block text-sm font-semibold mb-1">Nota</label>
              <textarea
                className="w-full border border-gray-200 rounded px-2 py-1 min-h-[50px]"
                value={odontogram[selectedTooth]?.note || ''}
                onChange={handleNoteChange}
                placeholder="Agregar nota..."
              />
            </div>
            <button className="mt-4 w-full bg-red-600 hover:bg-red-700 text-white font-bold py-2 rounded transition-all" onClick={closeModal} type="button">Cerrar</button>
          </div>
        </div>
      )}
    </div>
  );
};

export default Odontogram; 