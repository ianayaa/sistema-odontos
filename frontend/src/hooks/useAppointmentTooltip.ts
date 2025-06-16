import { useRef } from 'react';

let globalTooltip: HTMLDivElement | null = null;
let globalTooltipHideTimeout: NodeJS.Timeout | null = null;
let globalTooltipShowTimeout: NodeJS.Timeout | null = null;

export function useAppointmentTooltip() {
  // Forzar ocultar tooltip
  function forceHideAppointmentTooltip(inmediato = false) {
    if (globalTooltipShowTimeout) clearTimeout(globalTooltipShowTimeout);
    if (globalTooltipHideTimeout) clearTimeout(globalTooltipHideTimeout);
    if (globalTooltip) {
      globalTooltip.style.opacity = '0';
      if (inmediato) {
        globalTooltip.remove();
        globalTooltip = null;
      } else {
        setTimeout(() => {
          if (globalTooltip) {
            globalTooltip.remove();
            globalTooltip = null;
          }
        }, 120);
      }
    }
  }

  // Mostrar tooltip
  function showTooltip(e: MouseEvent, content: string) {
    forceHideAppointmentTooltip(true);
    if (globalTooltipHideTimeout) clearTimeout(globalTooltipHideTimeout);
    if (!globalTooltip) {
      globalTooltip = document.createElement('div');
      globalTooltip.innerHTML = content;
      globalTooltip.style.position = 'absolute';
      globalTooltip.style.zIndex = '9999';
      globalTooltip.style.pointerEvents = 'none';
      globalTooltip.style.opacity = '0';
      document.body.appendChild(globalTooltip);
    }
    const rect = (e.target as HTMLElement).getBoundingClientRect();
    globalTooltip.style.top = `${rect.bottom + window.scrollY + 8}px`;
    globalTooltip.style.left = `${rect.left + window.scrollX}px`;
    globalTooltipShowTimeout = setTimeout(() => {
      if (globalTooltip) globalTooltip.style.opacity = '1';
    }, 60);
  }

  // Ocultar tooltip
  function hideTooltip() {
    if (globalTooltipShowTimeout) clearTimeout(globalTooltipShowTimeout);
    if (globalTooltip) {
      globalTooltip.style.opacity = '0';
      globalTooltipHideTimeout = setTimeout(() => {
        if (globalTooltip) {
          globalTooltip.remove();
          globalTooltip = null;
        }
      }, 120);
    }
  }

  return { showTooltip, hideTooltip, forceHideAppointmentTooltip };
} 