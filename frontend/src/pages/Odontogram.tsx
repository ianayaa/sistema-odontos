import React, { useEffect, useRef } from 'react';
import api from '../services/api';

interface OdontogramProps {
  patientId: string;
}

interface ToothState {
  value: string;
  label: string;
  color: string;
  description?: string;
}

const TOOTH_STATES: ToothState[] = [
  { value: 'sano', label: 'Sano', color: '#fff', description: 'Diente sin patologías' },
  { value: 'caries', label: 'Caries', color: '#f87171', description: 'Presencia de caries' },
  { value: 'restaurado', label: 'Restaurado', color: '#60a5fa', description: 'Diente con restauración' },
  { value: 'ausente', label: 'Ausente', color: '#a3a3a3', description: 'Diente extraído o no erupcionado' },
  { value: 'movilidad', label: 'Movilidad', color: '#fbbf24', description: 'Movilidad dental' },
  { value: 'endodoncia', label: 'Endodoncia', color: '#8b5cf6', description: 'Tratamiento de conductos' },
  { value: 'corona', label: 'Corona', color: '#10b981', description: 'Diente con corona' },
  { value: 'implante', label: 'Implante', color: '#6366f1', description: 'Implante dental' },
];

const ADULT_TEETH_SCHEMA = [
  { n: 18, type: 'molar', x: 0, y: 0 },{ n: 17, type: 'molar', x: 1, y: 0 },{ n: 16, type: 'molar', x: 2, y: 0 },{ n: 15, type: 'premolar', x: 3, y: 0 },{ n: 14, type: 'premolar', x: 4, y: 0 },{ n: 13, type: 'canine', x: 5, y: 0 },{ n: 12, type: 'incisor', x: 6, y: 0 },{ n: 11, type: 'incisor', x: 7, y: 0 },{ n: 21, type: 'incisor', x: 8, y: 0 },{ n: 22, type: 'incisor', x: 9, y: 0 },{ n: 23, type: 'canine', x: 10, y: 0 },{ n: 24, type: 'premolar', x: 11, y: 0 },{ n: 25, type: 'premolar', x: 12, y: 0 },{ n: 26, type: 'molar', x: 13, y: 0 },{ n: 27, type: 'molar', x: 14, y: 0 },{ n: 28, type: 'molar', x: 15, y: 0 },{ n: 38, type: 'molar', x: 15, y: 1 },{ n: 37, type: 'molar', x: 14, y: 1 },{ n: 36, type: 'molar', x: 13, y: 1 },{ n: 35, type: 'premolar', x: 12, y: 1 },{ n: 34, type: 'premolar', x: 11, y: 1 },{ n: 33, type: 'canine', x: 10, y: 1 },{ n: 32, type: 'incisor', x: 9, y: 1 },{ n: 31, type: 'incisor', x: 8, y: 1 },{ n: 48, type: 'molar', x: 0, y: 1 },{ n: 47, type: 'molar', x: 1, y: 1 },{ n: 46, type: 'molar', x: 2, y: 1 },{ n: 45, type: 'premolar', x: 3, y: 1 },{ n: 44, type: 'premolar', x: 4, y: 1 },{ n: 43, type: 'canine', x: 5, y: 1 },{ n: 42, type: 'incisor', x: 6, y: 1 },{ n: 41, type: 'incisor', x: 7, y: 1 },
];

const GRID_X = 16;
const GRID_Y = 2;
const CELL_WIDTH = 55;
const CELL_HEIGHT = 80;
const SVG_WIDTH = GRID_X * CELL_WIDTH;
const SVG_HEIGHT = GRID_Y * CELL_HEIGHT + 40;

declare global {
  interface Window {
    Engine?: any;
  }
}

const Odontogram: React.FC<OdontogramProps> = ({ patientId }) => {
  const canvasRef = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    // Cargar scripts JS del odontograma-master solo una vez
    const scripts = [
      'constants.js',
      'settings.js',
      'rect.js',
      'damage.js',
      'textBox.js',
      'tooth.js',
      'menuItem.js',
      'renderer.js',
      'odontogramaGenerator.js',
      'collisionHandler.js',
      'engine.js',
    ];
    let loaded = 0;
    scripts.forEach(src => {
      const script = document.createElement('script');
      script.src = `/src/odontograma-canvas/${src}`;
      script.async = false;
      script.onload = () => {
        loaded++;
        if (loaded === scripts.length) {
          // Inicializar el engine JS
          if (window.Engine && canvasRef.current) {
            const engine = new window.Engine();
            engine.setCanvas(canvasRef.current);
            engine.init();
            // TODO: cargar estado desde backend y traducir menús
          }
        }
      };
      document.body.appendChild(script);
    });
    return () => {
      // Limpieza: eliminar scripts y canvas si se desmonta
      scripts.forEach(src => {
        const found = document.querySelector(`script[src*='${src}']`);
        if (found) found.remove();
      });
    };
  }, []);

  return (
    <div className="flex flex-col items-center justify-center min-h-[700px]">
      <canvas ref={canvasRef} id="canvas-odontograma" width={648} height={800} style={{borderRadius: 16, boxShadow: '0 4px 24px #0002'}} />
      {/* Aquí puedes agregar botones de guardar/cargar, leyenda, etc. */}
    </div>
  );
};

export default Odontogram;
