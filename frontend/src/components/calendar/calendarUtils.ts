// Utilidades para el calendario de citas

export function getContrastTextColor(bgColor: string) {
  // Si el color es en formato hex
  let color = bgColor;
  if (color.startsWith('rgb')) {
    // Convertir rgb a hex
    const rgb = color.match(/\d+/g);
    if (rgb && rgb.length >= 3) {
      color = '#' + rgb.slice(0, 3).map(x => (+x).toString(16).padStart(2, '0')).join('');
    }
  }
  if (color.startsWith('#')) {
    const hex = color.replace('#', '');
    const r = parseInt(hex.substring(0, 2), 16);
    const g = parseInt(hex.substring(2, 4), 16);
    const b = parseInt(hex.substring(4, 6), 16);
    // Luminancia relativa
    const luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
    return luminance > 0.6 ? '#222' : '#fff';
  }
  // Si no es hex, usar color oscuro por defecto
  return '#222';
} 