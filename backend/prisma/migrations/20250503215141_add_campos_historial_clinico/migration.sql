/*
  Warnings:

  - You are about to drop the column `alergiasAnestesicos` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `alergiasAntibioticos` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `alergiasDrogas` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `antecedentesNoPatologicos` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `antecedentesPatologicos` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `asmaBronquitisEnfisema` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `consentimiento` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `diagnostico` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `enfermedades` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `exploracionBucal` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `exploracionFisica` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `interrogatorio` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `medicamentos` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `motivo` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `padecimientoActual` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `padecimientosCardiacos` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `padecimientosSanguineos` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `planTratamiento` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `problemasHigado` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `problemasTiroides` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `pronostico` on the `MedicalHistory` table. All the data in the column will be lost.
  - The `angina` column on the `MedicalHistory` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `convulsiones` column on the `MedicalHistory` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `cortaduras` column on the `MedicalHistory` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `diabetesControlMedico` column on the `MedicalHistory` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `doloresPecho` column on the `MedicalHistory` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `extracciones` column on the `MedicalHistory` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `fiebreReumatica` column on the `MedicalHistory` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `infarto` column on the `MedicalHistory` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `nerviosismoDental` column on the `MedicalHistory` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `problemasRinonUrinarias` column on the `MedicalHistory` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `sangradoNasal` column on the `MedicalHistory` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- AlterTable
ALTER TABLE "MedicalHistory" DROP COLUMN "alergiasAnestesicos",
DROP COLUMN "alergiasAntibioticos",
DROP COLUMN "alergiasDrogas",
DROP COLUMN "antecedentesNoPatologicos",
DROP COLUMN "antecedentesPatologicos",
DROP COLUMN "asmaBronquitisEnfisema",
DROP COLUMN "consentimiento",
DROP COLUMN "diagnostico",
DROP COLUMN "enfermedades",
DROP COLUMN "exploracionBucal",
DROP COLUMN "exploracionFisica",
DROP COLUMN "interrogatorio",
DROP COLUMN "medicamentos",
DROP COLUMN "motivo",
DROP COLUMN "padecimientoActual",
DROP COLUMN "padecimientosCardiacos",
DROP COLUMN "padecimientosSanguineos",
DROP COLUMN "planTratamiento",
DROP COLUMN "problemasHigado",
DROP COLUMN "problemasTiroides",
DROP COLUMN "pronostico",
ADD COLUMN     "apellidoMaterno" TEXT,
ADD COLUMN     "apellidoPaterno" TEXT,
ADD COLUMN     "asma" BOOLEAN,
ADD COLUMN     "bradicardia" BOOLEAN,
ADD COLUMN     "bronquitis" BOOLEAN,
ADD COLUMN     "cirrosis" BOOLEAN,
ADD COLUMN     "enfisema" BOOLEAN,
ADD COLUMN     "hepatitisA" BOOLEAN,
ADD COLUMN     "hepatitisB" BOOLEAN,
ADD COLUMN     "hepatitisC" BOOLEAN,
ADD COLUMN     "hepatitisD" BOOLEAN,
ADD COLUMN     "hepatitisHigado" BOOLEAN,
ADD COLUMN     "herpes" BOOLEAN,
ADD COLUMN     "hipertension" BOOLEAN,
ADD COLUMN     "hipertiroidismo" BOOLEAN,
ADD COLUMN     "hipotension" BOOLEAN,
ADD COLUMN     "hipotiroidismo" BOOLEAN,
ADD COLUMN     "mesesEmbarazo" INTEGER,
ADD COLUMN     "taquicardia" BOOLEAN,
ADD COLUMN     "vih" BOOLEAN,
DROP COLUMN "angina",
ADD COLUMN     "angina" BOOLEAN,
DROP COLUMN "convulsiones",
ADD COLUMN     "convulsiones" BOOLEAN,
DROP COLUMN "cortaduras",
ADD COLUMN     "cortaduras" BOOLEAN,
DROP COLUMN "diabetesControlMedico",
ADD COLUMN     "diabetesControlMedico" BOOLEAN,
DROP COLUMN "doloresPecho",
ADD COLUMN     "doloresPecho" BOOLEAN,
DROP COLUMN "extracciones",
ADD COLUMN     "extracciones" BOOLEAN,
DROP COLUMN "fiebreReumatica",
ADD COLUMN     "fiebreReumatica" BOOLEAN,
DROP COLUMN "infarto",
ADD COLUMN     "infarto" BOOLEAN,
DROP COLUMN "nerviosismoDental",
ADD COLUMN     "nerviosismoDental" BOOLEAN,
DROP COLUMN "problemasRinonUrinarias",
ADD COLUMN     "problemasRinonUrinarias" BOOLEAN,
DROP COLUMN "sangradoNasal",
ADD COLUMN     "sangradoNasal" BOOLEAN;
