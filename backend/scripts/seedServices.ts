import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const servicios = [
  'Aclaramiento dental',
  'Aplicación de ácido hialurónico',
  'Aplicación de toxina botulínica (Botox)',
  'Cirugía del tercer molar',
  'Consulta en línea',
  'Consulta mensual de ortodoncia',
  'Corona metal porcelana',
  'Coronas dentales de zirconio',
  'Extracción dental',
  'Guarda oclusal',
  'Implantología',
  'Limpieza dental',
  'Prótesis dental fija y removible',
  'Rehabilitación bucal',
  'Rehabilitación protésica para implante',
  'Resinas dentales',
  'Retratamiento de Conductos',
  'Sedación consciente con óxido nitroso',
  'Terapia Láser para manejo del dolor',
  'Toma de impresión dental',
  'Tratamiento de Endodoncia',
  'Visita Odontología'
];

async function main() {
  await prisma.service.createMany({
    data: servicios.map(name => ({
      name,
      type: 'General',
      duration: 30,
      price: 0,
      assignedSchedules: '',
      description: name
    })),
    skipDuplicates: true
  });
  console.log('Servicios insertados (o ignorados si ya existían) correctamente');
}

main()
  .catch(e => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  }); 