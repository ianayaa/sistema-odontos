/*
  Warnings:

  - You are about to drop the column `allergies` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `conditions` on the `MedicalHistory` table. All the data in the column will be lost.
  - You are about to drop the column `medications` on the `MedicalHistory` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "MedicalHistory" DROP COLUMN "allergies",
DROP COLUMN "conditions",
DROP COLUMN "medications",
ADD COLUMN     "alergias" TEXT,
ADD COLUMN     "antecedentesNoPatologicos" TEXT,
ADD COLUMN     "antecedentesPatologicos" TEXT,
ADD COLUMN     "consentimiento" TEXT,
ADD COLUMN     "diagnostico" TEXT,
ADD COLUMN     "enfermedades" TEXT,
ADD COLUMN     "exploracionBucal" TEXT,
ADD COLUMN     "exploracionFisica" TEXT,
ADD COLUMN     "interrogatorio" TEXT,
ADD COLUMN     "medicamentos" TEXT,
ADD COLUMN     "motivo" TEXT,
ADD COLUMN     "padecimientoActual" TEXT,
ADD COLUMN     "planTratamiento" TEXT,
ADD COLUMN     "pronostico" TEXT;

-- CreateTable
CREATE TABLE "Odontogram" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "data" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Odontogram_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Odontogram" ADD CONSTRAINT "Odontogram_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
