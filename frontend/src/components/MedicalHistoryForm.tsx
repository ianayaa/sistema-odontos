import React, { useState, useEffect } from 'react';
import api from '../services/api';
import CustomSelect from './CustomSelect';
import { User, Users, Heart, Handshake, HeartBreak, Bird, Star, Smiley, SmileyMeh } from 'phosphor-react';

interface MedicalHistoryFormProps {
  patientId: string;
}

const initialState = {
  // Datos generales
  nombreCompleto: '',
  apellidoPaterno: '',
  apellidoMaterno: '',
  empleoProfesion: '',
  sexo: '',
  edad: '',
  estadoCivil: '',
  fechaNacimiento: '',
  lugarNacimiento: '',
  domicilio: '',
  telefonoDomicilio: '',
  telefonoOficina: '',
  escolaridad: '',
  ocupacion: '',
  interrogatorioTipo: '',
  nombreInformante: '',
  parentescoInformante: '',
  respuesta: '',
  temperatura: '',
  presionArterial: '',
  frecuenciaCardiaca: '',
  // Antecedentes preliminares
  urgencia: '',
  compania: '',
  motivoConsulta: '',
  fechaUltimaConsultaMedica: '',
  motivoUltimaConsultaMedica: '',
  padecimientoOdontologicoActual: '',
  tipoSanguineo: '',
  rh: '',
  hepatitisA: false,
  hepatitisB: false,
  hepatitisC: false,
  hepatitisD: false,
  vih: false,
  herpes: false,
  alergias: '',
  terapeuticaEmpleada: '',
  saludGeneral: '',
  nerviosismoDental: false,
  convulsiones: false,
  // Antecedentes médicos
  asma: false,
  bronquitis: false,
  enfisema: false,
  fuma: false,
  cigarrillosPorDia: '',
  taquicardia: false,
  bradicardia: false,
  hipertension: false,
  hipotension: false,
  doloresPecho: false,
  infarto: false,
  angina: false,
  fiebreReumatica: false,
  edadFiebreReumatica: '',
  sangrado: '',
  extracciones: false,
  sangradoNasal: false,
  cortaduras: false,
  periodoMenstrual: 'NO',
  fum: '',
  embarazo: false,
  mesesEmbarazo: '',
  padecimientosGastricos: '',
  diabetes: false,
  diabetesControlMedico: false,
  hipotiroidismo: false,
  hipertiroidismo: false,
  hepatitisHigado: false,
  cirrosis: false,
  problemasRinonUrinarias: false,
  medicamentosActuales: '',
  otrasCondicionesMedicas: '',
  procesosQuirurgicos: '',
  tratamientosHormonales: '',
  // Campos previos
  motivo: '',
  padecimientoActual: '',
  antecedentesPatologicos: '',
  antecedentesNoPatologicos: '',
  interrogatorio: '',
  medicamentos: '',
  enfermedades: '',
  exploracionFisica: '',
  exploracionBucal: '',
  diagnostico: '',
  pronostico: '',
  planTratamiento: '',
  consentimiento: '',
  notas: '',
};

const requiredFields = [
  'nombreCompleto', 'apellidoPaterno', 'sexo', 'edad', 'fechaNacimiento', 'telefonoDomicilio', 'motivoConsulta', 'padecimientoOdontologicoActual'
];

const sexoOptionsCustom = [
  { value: '', label: 'Selecciona', icon: <User className="text-gray-400" size={18} /> },
  { value: 'M', label: 'Masculino', icon: <User className="text-blue-500" size={18} /> },
  { value: 'F', label: 'Femenino', icon: <User className="text-pink-500" size={18} /> },
];

const estadoCivilOptionsCustom = [
  { value: '', label: 'Selecciona', icon: <Users className="text-gray-400" size={18} /> },
  { value: 'S', label: 'Soltero/a', icon: <User className="text-gray-500" size={18} /> },
  { value: 'C', label: 'Casado/a', icon: <Heart className="text-red-500" size={18} /> },
  { value: 'V', label: 'Viudo/a', icon: <Bird className="text-blue-400" size={18} /> },
  { value: 'D', label: 'Divorciado/a', icon: <HeartBreak className="text-red-400" size={18} /> },
  { value: 'UL', label: 'Unión libre', icon: <Handshake className="text-green-500" size={18} /> },
];

const saludGeneralOptionsCustom = [
  { value: '', label: 'Selecciona', icon: <SmileyMeh className="text-gray-400" size={18} /> },
  { value: 'Buena', label: 'Buena', icon: <Smiley className="text-green-500" size={18} /> },
  { value: 'Regular', label: 'Regular', icon: <SmileyMeh className="text-yellow-500" size={18} /> },
  { value: 'Excelente', label: 'Excelente', icon: <Star className="text-yellow-400" size={18} /> },
];

const siNoOptions = [
  { value: '', label: 'Selecciona' },
  { value: 'SI', label: 'Sí' },
  { value: 'NO', label: 'No' },
];

const MedicalHistoryForm: React.FC<MedicalHistoryFormProps> = ({ patientId }) => {
  const [form, setForm] = useState(initialState);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [success, setSuccess] = useState(false);
  const [historyId, setHistoryId] = useState<string | null>(null);

  useEffect(() => {
    setLoading(true);
    api.get(`/medical-history/patient/${patientId}`)
      .then(res => {
        if (res.data) {
          setForm({
            ...initialState,
            ...Object.fromEntries(Object.keys(initialState).map(key => [key, res.data[key as keyof typeof initialState] ?? initialState[key as keyof typeof initialState]])),
          });
          setHistoryId(res.data.id || null);
        } else {
          setForm(initialState);
          setHistoryId(null);
        }
      })
      .catch(() => {
        setForm(initialState);
        setHistoryId(null);
      })
      .finally(() => setLoading(false));
  }, [patientId]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value, type } = e.target;
    if (type === 'checkbox') {
      setForm({
        ...form,
        [name]: (e.target as HTMLInputElement).checked
      });
    } else {
      setForm({
        ...form,
        [name]: value
      });
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    try {
      if (historyId) {
        await api.put(`/medical-history/patient/${patientId}`, form);
      } else {
        await api.post('/medical-history', { patientId, ...form });
      }
      setSuccess(true);
      setTimeout(() => setSuccess(false), 2000);
    } catch (err) {
      // Manejar error
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return <div className="text-gray-500 text-center py-8">Cargando historia clínica...</div>;
  }

  return (
    <form onSubmit={handleSubmit} className="bg-white rounded-xl shadow p-6 space-y-8 border border-gray-100 mt-4">
      <h3 className="text-xl font-bold mb-2 text-red-700">Historia Clínica Odontológica</h3>
      {/* DATOS GENERALES */}
      <div>
        <h4 className="text-lg font-semibold text-gray-700 mb-2">Datos generales</h4>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Nombre(s)</label>
            <input type="text" name="nombreCompleto" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.nombreCompleto} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Apellido paterno</label>
            <input type="text" name="apellidoPaterno" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.apellidoPaterno} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Apellido materno</label>
            <input type="text" name="apellidoMaterno" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.apellidoMaterno} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Empleo o profesión</label>
            <input type="text" name="empleoProfesion" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.empleoProfesion} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Sexo</label>
            <CustomSelect
              value={form.sexo}
              onChange={value => setForm({ ...form, sexo: value })}
              options={sexoOptionsCustom}
              placeholder="Selecciona sexo"
            />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Edad</label>
            <input type="text" name="edad" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.edad} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Estado civil</label>
            <CustomSelect
              value={form.estadoCivil}
              onChange={value => setForm({ ...form, estadoCivil: value })}
              options={estadoCivilOptionsCustom}
              placeholder="Selecciona estado civil"
            />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Fecha de nacimiento</label>
            <input type="date" name="fechaNacimiento" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.fechaNacimiento} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Lugar de nacimiento</label>
            <input type="text" name="lugarNacimiento" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.lugarNacimiento} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Domicilio</label>
            <input type="text" name="domicilio" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.domicilio} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Teléfono (domicilio)</label>
            <input type="tel" name="telefonoDomicilio" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.telefonoDomicilio} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Teléfono (oficina)</label>
            <input type="tel" name="telefonoOficina" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.telefonoOficina} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Escolaridad</label>
            <input type="text" name="escolaridad" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.escolaridad} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Ocupación</label>
            <input type="text" name="ocupacion" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.ocupacion} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Interrogatorio</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="interrogatorioTipo" value="Directo" checked={form.interrogatorioTipo === 'Directo'} onChange={handleChange} />
                Directo
              </label>
              <label className="flex items-center gap-2">
                <input type="checkbox" name="interrogatorioTipo" value="Indirecto" checked={form.interrogatorioTipo === 'Indirecto'} onChange={handleChange} />
                Indirecto
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Nombre del informante</label>
            <input type="text" name="nombreInformante" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.nombreInformante} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Parentesco</label>
            <input type="text" name="parentescoInformante" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.parentescoInformante} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Respuesta</label>
            <input type="text" name="respuesta" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.respuesta} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Temperatura</label>
            <input type="text" name="temperatura" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.temperatura} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">P.A.</label>
            <input type="text" name="presionArterial" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.presionArterial} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">F.C.</label>
            <input type="text" name="frecuenciaCardiaca" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.frecuenciaCardiaca} onChange={handleChange} />
          </div>
        </div>
      </div>
      {/* ANTECEDENTES PRELIMINARES */}
      <div>
        <h4 className="text-lg font-semibold text-gray-700 mb-2">Antecedentes preliminares</h4>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Urgencia</label>
            <input type="text" name="urgencia" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.urgencia} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Compañía</label>
            <input type="text" name="compania" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.compania} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Motivo de la consulta</label>
            <textarea name="motivoConsulta" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50 min-h-[60px]" value={form.motivoConsulta} onChange={handleChange} required />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Fecha de la última consulta médica</label>
            <input type="date" name="fechaUltimaConsultaMedica" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.fechaUltimaConsultaMedica} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Motivo de la última consulta médica</label>
            <textarea name="motivoUltimaConsultaMedica" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50 min-h-[60px]" value={form.motivoUltimaConsultaMedica} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Padecimiento odontológico actual</label>
            <textarea name="padecimientoOdontologicoActual" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50 min-h-[60px]" value={form.padecimientoOdontologicoActual} onChange={handleChange} required />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Tipo sanguíneo</label>
            <input type="text" name="tipoSanguineo" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.tipoSanguineo} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">RH</label>
            <input type="text" name="rh" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.rh} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Padecimientos sanguíneos</label>
            <div className="flex flex-wrap gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="hepatitisA" checked={form.hepatitisA} onChange={handleChange} />
                Hepatitis A
              </label>
              <label className="flex items-center gap-2">
                <input type="checkbox" name="hepatitisB" checked={form.hepatitisB} onChange={handleChange} />
                Hepatitis B
              </label>
              <label className="flex items-center gap-2">
                <input type="checkbox" name="hepatitisC" checked={form.hepatitisC} onChange={handleChange} />
                Hepatitis C
              </label>
              <label className="flex items-center gap-2">
                <input type="checkbox" name="hepatitisD" checked={form.hepatitisD} onChange={handleChange} />
                Hepatitis D
              </label>
              <label className="flex items-center gap-2">
                <input type="checkbox" name="vih" checked={form.vih} onChange={handleChange} />
                VIH
              </label>
              <label className="flex items-center gap-2">
                <input type="checkbox" name="herpes" checked={form.herpes} onChange={handleChange} />
                Herpes
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Alergias</label>
            <textarea name="alergias" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50 min-h-[60px]" value={form.alergias} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Terapéutica empleada</label>
            <textarea name="terapeuticaEmpleada" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50 min-h-[60px]" value={form.terapeuticaEmpleada} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Salud general</label>
            <CustomSelect
              value={form.saludGeneral}
              onChange={value => setForm({ ...form, saludGeneral: value })}
              options={saludGeneralOptionsCustom}
              placeholder="Selecciona salud general"
            />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Nerviosismo dental</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="nerviosismoDental" checked={form.nerviosismoDental} onChange={handleChange} />
                Sí
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Convulsiones</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="convulsiones" checked={form.convulsiones} onChange={handleChange} />
                Sí
              </label>
            </div>
          </div>
        </div>
      </div>
      {/* ANTECEDENTES MÉDICOS */}
      <div>
        <h4 className="text-lg font-semibold text-gray-700 mb-2">Antecedentes médicos</h4>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Asma</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="asma" checked={form.asma} onChange={handleChange} />
                Sí
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Bronquitis</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="bronquitis" checked={form.bronquitis} onChange={handleChange} />
                Sí
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Enfisema pulmonar</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="enfisema" checked={form.enfisema} onChange={handleChange} />
                Sí
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">¿Fuma?</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="fuma" checked={form.fuma} onChange={handleChange} />
                Sí
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">¿Cuántos cigarrillos?</label>
            <input type="number" name="cigarrillosPorDia" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.cigarrillosPorDia} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Cardiopatías</label>
            <div className="flex flex-wrap gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="taquicardia" checked={form.taquicardia} onChange={handleChange} />
                Taquicardia
              </label>
              <label className="flex items-center gap-2">
                <input type="checkbox" name="bradicardia" checked={form.bradicardia} onChange={handleChange} />
                Bradicardia
              </label>
              <label className="flex items-center gap-2">
                <input type="checkbox" name="hipertension" checked={form.hipertension} onChange={handleChange} />
                Hipertensión
              </label>
              <label className="flex items-center gap-2">
                <input type="checkbox" name="hipotension" checked={form.hipotension} onChange={handleChange} />
                Hipotensión
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Dolores de pecho</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="doloresPecho" checked={form.doloresPecho} onChange={handleChange} />
                Sí
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Infarto</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="infarto" checked={form.infarto} onChange={handleChange} />
                Sí
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Angina de pecho</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="angina" checked={form.angina} onChange={handleChange} />
                Sí
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Fiebre reumática</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="fiebreReumatica" checked={form.fiebreReumatica} onChange={handleChange} />
                Sí
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Edad fiebre reumática</label>
            <input type="number" name="edadFiebreReumatica" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.edadFiebreReumatica} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Sangrado prolongado/excesivo</label>
            <textarea name="sangrado" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50 min-h-[60px]" value={form.sangrado} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Extracciones dentales</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="extracciones" checked={form.extracciones} onChange={handleChange} />
                Sí
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Sangrado nasal espontáneo</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="sangradoNasal" checked={form.sangradoNasal} onChange={handleChange} />
                Sí
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Cortaduras de piel</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="cortaduras" checked={form.cortaduras} onChange={handleChange} />
                Sí
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Periodo menstrual</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="periodoMenstrual" checked={form.periodoMenstrual === 'SI'} onChange={(e) => {
                  setForm({
                    ...form,
                    periodoMenstrual: e.target.checked ? 'SI' : 'NO',
                    fum: e.target.checked ? form.fum : ''
                  });
                }} />
                Sí
              </label>
            </div>
            {form.periodoMenstrual === 'SI' && (
              <div className="mt-2">
                <label className="block text-sm font-semibold text-gray-700 mb-1">Fecha de última menstruación (FUM)</label>
                <input type="date" name="fum" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.fum} onChange={handleChange} />
              </div>
            )}
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Embarazo</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="embarazo" checked={form.embarazo} onChange={handleChange} />
                Sí
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Meses de embarazo</label>
            <input type="number" name="mesesEmbarazo" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50" value={form.mesesEmbarazo} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Padecimientos gástricos</label>
            <textarea name="padecimientosGastricos" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50 min-h-[60px]" value={form.padecimientosGastricos} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Diabetes</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="diabetes" checked={form.diabetes} onChange={handleChange} />
                Sí
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Bajo control médico</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="diabetesControlMedico" checked={form.diabetesControlMedico} onChange={handleChange} />
                Sí
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Problemas de tiroides</label>
            <div className="flex flex-wrap gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="hipotiroidismo" checked={form.hipotiroidismo} onChange={handleChange} />
                Hipotiroidismo
              </label>
              <label className="flex items-center gap-2">
                <input type="checkbox" name="hipertiroidismo" checked={form.hipertiroidismo} onChange={handleChange} />
                Hipertiroidismo
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Problemas de hígado</label>
            <div className="flex flex-wrap gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="hepatitisHigado" checked={form.hepatitisHigado} onChange={handleChange} />
                Hepatitis
              </label>
              <label className="flex items-center gap-2">
                <input type="checkbox" name="cirrosis" checked={form.cirrosis} onChange={handleChange} />
                Cirrosis
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Problemas de riñón/vías urinarias</label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="problemasRinonUrinarias" checked={form.problemasRinonUrinarias} onChange={handleChange} />
                Sí
              </label>
            </div>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Medicamentos actuales</label>
            <textarea name="medicamentosActuales" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50 min-h-[60px]" value={form.medicamentosActuales} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Otras condiciones médicas</label>
            <textarea name="otrasCondicionesMedicas" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50 min-h-[60px]" value={form.otrasCondicionesMedicas} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Procesos quirúrgicos</label>
            <textarea name="procesosQuirurgicos" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50 min-h-[60px]" value={form.procesosQuirurgicos} onChange={handleChange} />
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Tratamientos hormonales</label>
            <textarea name="tratamientosHormonales" className="w-full border border-gray-200 rounded-lg px-4 py-2 bg-gray-50 min-h-[60px]" value={form.tratamientosHormonales} onChange={handleChange} />
          </div>
        </div>
      </div>
      <div className="flex justify-end gap-4">
        <button
          type="submit"
          className="bg-red-600 hover:bg-red-700 text-white font-bold px-6 py-2 rounded-lg transition-all duration-200 shadow disabled:opacity-60"
          disabled={saving}
        >
          {saving ? 'Guardando...' : 'Guardar'}
        </button>
        {success && <span className="text-green-600 font-semibold self-center">¡Guardado!</span>}
      </div>
    </form>
  );
};

export default MedicalHistoryForm;
