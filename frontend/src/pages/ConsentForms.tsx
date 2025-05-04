import React, { useEffect, useState } from 'react';
import DashboardLayout from '../components/DashboardLayout';
import { FileText } from 'phosphor-react';

interface ConsentForm {
  id: string;
  name: string;
  content: string;
  createdAt: string;
}

const ConsentForms: React.FC = () => {
  const [consentForms, setConsentForms] = useState<ConsentForm[]>([]);
  const [loading, setLoading] = useState(true);
  const [showModal, setShowModal] = useState(false);
  const [search, setSearch] = useState('');

  useEffect(() => {
    // Aquí iría la llamada a la API
    setLoading(false);
  }, []);

  const filteredForms = consentForms.filter(form => {
    const q = search.toLowerCase();
    return form.name.toLowerCase().includes(q);
  });

  return (
    <DashboardLayout>
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
        <div className="flex items-center gap-4 flex-1 mb-2 sm:mb-0">
          <div className="bg-red-100 text-red-600 rounded-full p-3">
            <FileText size={38} weight="duotone" />
          </div>
          <div>
            <h2 className="text-2xl font-bold text-gray-800 mb-1">Consentimientos</h2>
            <p className="text-gray-500 text-base font-medium">Gestión de consentimientos informados.</p>
          </div>
        </div>
        <div className="flex items-center gap-2 w-full sm:w-auto">
          <div className="relative w-full max-w-xs">
            <input
              type="text"
              placeholder="Buscar por nombre..."
              className="w-full pl-12 pr-4 py-2 rounded-xl border-2 border-gray-200 focus:border-red-400 focus:ring-2 focus:ring-red-100 text-gray-700 bg-white shadow transition-all placeholder-gray-400"
              value={search}
              onChange={e => setSearch(e.target.value)}
              autoComplete="off"
              spellCheck={false}
            />
            <span className="absolute left-4 top-1/2 -translate-y-1/2 text-red-400 pointer-events-none">
              <svg width="22" height="22" fill="none" stroke="currentColor" strokeWidth="2.2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="M21 21l-2-2"/></svg>
            </span>
            {search && (
              <button
                type="button"
                className="absolute right-2 top-1/2 -translate-y-1/2 text-gray-300 hover:text-red-400 text-xl px-1 focus:outline-none"
                onClick={() => setSearch('')}
                tabIndex={-1}
                aria-label="Limpiar búsqueda"
              >
                ×
              </button>
            )}
          </div>
          <button
            className="bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-lg transition-all duration-200 shadow-md ml-2 whitespace-nowrap text-base"
            style={{ minHeight: '40px', minWidth: 'auto', fontSize: '1rem', paddingTop: '0.5rem', paddingBottom: '0.5rem', paddingLeft: '1rem', paddingRight: '1rem' }}
            onClick={() => setShowModal(true)}
          >
            + Nuevo Consentimiento
          </button>
        </div>
      </div>
      {loading ? (
        <div className="bg-white rounded-2xl shadow-xl p-8 text-center text-gray-400">
          <FileText size={64} weight="duotone" className="mx-auto mb-2" />
          <div className="text-lg font-semibold mb-2">Cargando consentimientos...</div>
        </div>
      ) : filteredForms.length === 0 ? (
        <div className="bg-white rounded-2xl shadow-xl p-8 text-center text-gray-400">
          <FileText size={64} weight="duotone" className="mx-auto mb-2" />
          <div className="text-lg font-semibold mb-2">No se encontraron consentimientos</div>
          <div className="mb-4">Prueba ajustando tu búsqueda o agrega un nuevo consentimiento.</div>
        </div>
      ) : (
        <div className="bg-white rounded-2xl shadow-xl overflow-x-auto border border-gray-200">
          <table className="min-w-full divide-y divide-gray-100">
            <thead className="bg-gray-50 sticky top-0 z-10">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Nombre</th>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Fecha de Creación</th>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Acciones</th>
              </tr>
            </thead>
            <tbody>
              {filteredForms.map(form => (
                <tr key={form.id} className="hover:bg-red-50 transition-all border-b border-gray-100 last:border-0 group">
                  <td className="px-6 py-4 flex items-center gap-3 font-medium text-gray-900">
                    <div className="bg-red-100 rounded-full h-10 w-10 flex items-center justify-center text-red-600 font-bold text-lg shadow-sm">
                      <FileText size={24} weight="duotone" />
                    </div>
                    <span>{form.name}</span>
                  </td>
                  <td className="px-6 py-4">{new Date(form.createdAt).toLocaleDateString()}</td>
                  <td className="px-6 py-4 text-right">
                    <button
                      onClick={() => {/* Aquí iría la lógica para editar */}}
                      className="inline-flex items-center gap-1 text-red-600 hover:text-white hover:bg-red-600 border border-red-200 font-semibold px-3 py-1.5 rounded-lg transition-all duration-150 focus:outline-none focus:ring-2 focus:ring-red-300 group-hover:bg-red-600 group-hover:text-white"
                    >
                      <svg width="20" height="20" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                      Editar
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </DashboardLayout>
  );
};

export default ConsentForms; 