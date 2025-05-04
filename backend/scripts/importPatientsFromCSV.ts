import { PrismaClient } from '@prisma/client';
import fs from 'fs';
import { parse } from 'csv-parse';

const prisma = new PrismaClient();

// Borra todos los pacientes y sus datos relacionados
async function deleteAllPatients() {
  await prisma.payment.deleteMany({});
  await prisma.appointment.deleteMany({});
  await prisma.consultation.deleteMany({});
  await prisma.medicalHistory.deleteMany({});
  await prisma.odontogram.deleteMany({});
  await prisma.patient.deleteMany({});
}

// Mapea los nombres de las columnas del CSV a los campos de la base de datos
interface PatientCSV {
  'first name': string;
  'last name': string;
  phone: string;
  email: string;
  'date of birth': string;
  // Puedes agregar más campos si los necesitas
}

async function main() {
  await deleteAllPatients();
  const patients: any[] = [];
  const notImported: string[] = [];
  const parser = fs
    .createReadStream(__dirname + '/patients_utf8.csv')
    .pipe(parse({ columns: true, delimiter: ';', skip_empty_lines: true, relax_quotes: true }));

  for await (const record of parser) {
    try {
      // Importa si hay al menos nombre, apellido o teléfono
      const name = record['first name']?.trim() || '';
      const lastName = record['last name']?.trim() || '';
      const email = record['email']?.trim() || null;
      const phone = record['phone']?.replace(/[^\d+]/g, '').trim() || null;
      let birthDate = record['date of birth']?.trim() || null;
      // Si la fecha existe y es válida, conviértela a Date, si no, pon null
      if (birthDate) {
        const dateObj = new Date(birthDate);
        if (!isNaN(dateObj.getTime())) {
          birthDate = dateObj;
        } else {
          birthDate = null;
        }
      } else {
        birthDate = null;
      }

      if (!name && !lastName && !phone) {
        notImported.push(`Fila ignorada: ${JSON.stringify(record)}`);
        continue;
      }

      patients.push({
        name: name || '-',
        lastNamePaterno: lastName || '-',
        lastNameMaterno: '',
        email,
        phone,
        birthDate,
        address: ''
      });
    } catch (err) {
      notImported.push(`Error al procesar fila: ${JSON.stringify(record)} - ${err}`);
      continue;
    }
  }

  let count = 0;
  for (const p of patients) {
    try {
      await prisma.patient.create({ data: p });
      count++;
    } catch (e: any) {
      notImported.push(`Error al insertar paciente: ${JSON.stringify(p)} - ${e.message}`);
    }
  }
  fs.writeFileSync(__dirname + '/no_importados.log', notImported.join('\n'));
  console.log(`Importación terminada. Pacientes insertados: ${count}`);
  console.log(`Pacientes no importados: ${notImported.length}. Ver no_importados.log`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  }); 