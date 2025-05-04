import React, { useEffect, useState } from 'react';
import DashboardLayout from '../components/DashboardLayout';
import { FirstAid } from 'phosphor-react';
import { Button, Table, Modal, Form, Input, InputNumber, Select } from 'antd';

interface ServiceItem {
  id: string;
  name: string;
  type: string;
  duration: number;
  price: number;
  assignedSchedules: string;
  description: string;
  color?: string;
}

interface UserOption {
  id: string;
  name: string;
  lastNamePaterno?: string;
  lastNameMaterno?: string;
  role: string;
}

const Servicios: React.FC = () => {
  const [services, setServices] = useState<ServiceItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [showModal, setShowModal] = useState(false);
  const [search, setSearch] = useState('');
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [form] = Form.useForm();
  const [editingService, setEditingService] = useState<ServiceItem | null>(null);
  const [userOptions, setUserOptions] = useState<UserOption[]>([]);

  useEffect(() => {
    setLoading(true);
    fetch('/api/services')
      .then(res => res.json())
      .then(data => {
        setServices(data);
        setLoading(false);
      })
      .catch(() => setLoading(false));
    // Cargar usuarios para el select
    const token = localStorage.getItem('token');
    fetch('/api/users', {
      headers: {
        'Authorization': token ? `Bearer ${token}` : ''
      }
    })
      .then(res => {
        if (!res.ok) throw new Error('No autorizado');
        return res.json();
      })
      .then(data => {
        if (Array.isArray(data)) {
          // Filtrar solo odontólogos y asistentes
          setUserOptions(data.filter(u => u.role === 'DENTIST' || u.role === 'ASSISTANT'));
        } else {
          setUserOptions([]);
        }
      })
      .catch(() => setUserOptions([]));
  }, []);

  const filteredItems = services.filter(item => {
    const q = search.toLowerCase();
    return (
      item.name.toLowerCase().includes(q) ||
      item.type.toLowerCase().includes(q) ||
      item.description.toLowerCase().includes(q)
    );
  });

  const columns = [
    {
      title: 'Nombre',
      dataIndex: 'name',
      key: 'name',
      render: (_: any, record: ServiceItem) => (
        <span className="flex items-center gap-2">
          {record.color && (
            <span className="inline-block w-4 h-4 rounded-full border border-gray-200" style={{ background: record.color }}></span>
          )}
          {record.name}
        </span>
      )
    },
    {
      title: 'Tipo de servicio',
      dataIndex: 'type',
      key: 'type',
    },
    {
      title: 'Duración',
      dataIndex: 'duration',
      key: 'duration',
      render: (value: number) => `${value} min`,
    },
    {
      title: 'Precio',
      dataIndex: 'price',
      key: 'price',
      render: (value: number) => `$${value.toLocaleString('es-MX', { minimumFractionDigits: 2 })}`,
    },
    {
      title: 'Descripción',
      dataIndex: 'description',
      key: 'description',
    },
    {
      title: 'Acciones',
      key: 'actions',
      render: (_: any, record: ServiceItem) => (
        <Button type="link" onClick={() => handleEdit(record)}>
          Editar
        </Button>
      ),
    },
  ];

  const handleEdit = (service: ServiceItem) => {
    setEditingService(service);
    form.setFieldsValue({
      ...service
    });
    setIsModalVisible(true);
  };

  const handleSave = async (values: any) => {
    const payload = {
      ...values,
    };
    if (editingService) {
      await fetch(`/api/services/${editingService.id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });
      setServices(prev => prev.map(s => s.id === editingService.id ? { ...s, ...payload } : s));
    } else {
      const res = await fetch('/api/services', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });
      const newService = await res.json();
      setServices(prev => [...prev, newService]);
    }
    setIsModalVisible(false);
    setEditingService(null);
    form.resetFields();
  };

  return (
    <DashboardLayout>
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
        <div className="flex items-center gap-4 flex-1 mb-2 sm:mb-0">
          <div className="bg-red-100 text-red-600 rounded-full p-3">
            <FirstAid size={38} weight="duotone" />
          </div>
          <div>
            <h2 className="text-2xl font-bold text-gray-800 mb-1">Servicios</h2>
            <p className="text-gray-500 text-base font-medium">Gestión de servicios ofrecidos en la clínica.</p>
          </div>
        </div>
        <div className="flex items-center gap-2 w-full sm:w-auto">
          <div className="relative w-full max-w-xs">
            <input
              type="text"
              placeholder="Buscar por nombre, tipo de servicio o descripción..."
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
            onClick={() => setIsModalVisible(true)}
          >
            + Nuevo Servicio
          </button>
        </div>
      </div>
      {loading ? (
        <div className="bg-white rounded-2xl shadow-xl p-8 text-center text-gray-400">
          <FirstAid size={64} weight="duotone" className="mx-auto mb-2" />
          <div className="text-lg font-semibold mb-2">Cargando servicios...</div>
        </div>
      ) : filteredItems.length === 0 ? (
        <div className="bg-white rounded-2xl shadow-xl p-8 text-center text-gray-400">
          <FirstAid size={64} weight="duotone" className="mx-auto mb-2" />
          <div className="text-lg font-semibold mb-2">No se encontraron servicios</div>
          <div className="mb-4">Prueba ajustando tu búsqueda o agrega un nuevo servicio.</div>
        </div>
      ) : (
        <div className="bg-white rounded-2xl shadow-xl overflow-x-auto border border-gray-200">
          <table className="min-w-full divide-y divide-gray-100">
            <thead className="bg-gray-50 sticky top-0 z-10">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Nombre</th>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Tipo de servicio</th>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Duración</th>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Precio</th>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Descripción</th>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Acciones</th>
              </tr>
            </thead>
            <tbody>
              {filteredItems.map(item => (
                <tr key={item.id} className="hover:bg-red-50 transition-all border-b border-gray-100 last:border-0 group">
                  <td className="px-6 py-4 flex items-center gap-3 font-medium text-gray-900">
                    <div className="bg-red-100 rounded-full h-10 w-10 flex items-center justify-center text-red-600 font-bold text-lg shadow-sm">
                      <FirstAid size={24} weight="duotone" />
                    </div>
                    <span>{item.name}</span>
                  </td>
                  <td className="px-6 py-4">{item.type}</td>
                  <td className="px-6 py-4">{item.duration} min</td>
                  <td className="px-6 py-4">${item.price.toLocaleString('es-MX', { minimumFractionDigits: 2 })}</td>
                  <td className="px-6 py-4">{item.description}</td>
                  <td className="px-6 py-4 text-right">
                    <button
                      onClick={() => handleEdit(item)}
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

      {isModalVisible && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-lg p-0 relative overflow-hidden animate-fadeInUp">
            <div className="flex items-center gap-3 bg-gradient-to-r from-red-100 to-red-50 px-8 py-6 border-b border-red-100">
              <div className="bg-red-200 text-red-600 rounded-full p-3">
                <FirstAid size={30} weight="duotone" />
              </div>
              <div className="flex-1">
                <h3 className="text-xl font-bold text-gray-800">{editingService ? 'Editar Servicio' : 'Nuevo Servicio'}</h3>
                <div className="text-gray-400 text-sm">Completa los datos para {editingService ? 'editar' : 'registrar'} el servicio</div>
              </div>
              <button
                className="ml-auto text-gray-400 hover:text-red-600 text-2xl font-bold p-1 rounded-full transition-colors focus:outline-none"
                onClick={() => { setIsModalVisible(false); setEditingService(null); form.resetFields(); }}
                aria-label="Cerrar"
                type="button"
              >
                <svg width="28" height="28" fill="none" stroke="#e11d48" strokeWidth="2.2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M15 9l-6 6M9 9l6 6"/></svg>
              </button>
            </div>
            <Form
              form={form}
              layout="vertical"
              className="px-8 py-7 space-y-4"
              onFinish={handleSave}
              initialValues={editingService || {}}
            >
              <Form.Item
                name="name"
                label={<span className="font-semibold text-gray-700">Nombre del Servicio</span>}
                rules={[{ required: true, message: 'Ingresa el nombre del servicio' }]}
              >
                <Input className="rounded-xl border-gray-200 focus:border-red-400 focus:ring-2 focus:ring-red-100" placeholder="Ej. Limpieza dental" />
              </Form.Item>
              <Form.Item
                name="type"
                label={<span className="font-semibold text-gray-700">Tipo de servicio</span>}
                rules={[{ required: true, message: 'Ingresa el tipo de servicio' }]}
              >
                <Input className="rounded-xl border-gray-200 focus:border-red-400 focus:ring-2 focus:ring-red-100" placeholder="Ej. Preventivo, Estético..." />
              </Form.Item>
              <Form.Item
                name="duration"
                label={<span className="font-semibold text-gray-700">Duración (minutos)</span>}
                rules={[{ required: true, type: 'number', min: 1, message: 'Duración mínima 1 minuto' }]}
              >
                <InputNumber min={1} className="w-full rounded-xl border-gray-200 focus:border-red-400 focus:ring-2 focus:ring-red-100" placeholder="Ej. 30" />
              </Form.Item>
              <Form.Item
                name="price"
                label={<span className="font-semibold text-gray-700">Precio ($ MXN)</span>}
                rules={[{ required: true, type: 'number', min: 0, message: 'El precio debe ser mayor o igual a 0' }]}
              >
                <InputNumber min={0} className="w-full rounded-xl border-gray-200 focus:border-red-400 focus:ring-2 focus:ring-red-100" placeholder="Ej. 500" />
              </Form.Item>
              <Form.Item
                name="description"
                label={<span className="font-semibold text-gray-700">Descripción</span>}
                rules={[{ required: true, message: 'Agrega una descripción' }]}
              >
                <Input.TextArea rows={3} className="rounded-xl border-gray-200 focus:border-red-400 focus:ring-2 focus:ring-red-100" placeholder="Describe brevemente el servicio..." />
              </Form.Item>
              <Form.Item
                name="color"
                label={<span className="font-semibold text-gray-700">Color del Servicio</span>}
                rules={[{ required: true, message: 'Selecciona un color para el servicio' }]}
              >
                <Input
                  type="color"
                  className="w-12 h-8 p-0 border-none bg-transparent cursor-pointer"
                  style={{ padding: 0, width: 48, height: 32 }}
                />
              </Form.Item>
              <div className="flex justify-end mt-6">
                <button
                  type="submit"
                  className="w-full bg-gradient-to-r from-red-600 to-red-500 hover:from-red-700 hover:to-red-600 text-white font-bold py-2 px-4 rounded-xl transition-all duration-200 shadow-md text-base"
                >
                  Guardar Servicio
                </button>
              </div>
            </Form>
          </div>
        </div>
      )}
    </DashboardLayout>
  );
};

export default Servicios; 