/*
  Warnings:

  - You are about to drop the column `date` on the `Odontogram` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[patientId]` on the table `Odontogram` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "Odontogram" DROP COLUMN "date";

-- AlterTable
ALTER TABLE "Patient" ALTER COLUMN "phone" DROP NOT NULL;

-- CreateTable
CREATE TABLE "Consultation" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "motivo" TEXT,
    "diagnostico" TEXT,
    "tratamiento" TEXT,
    "observaciones" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Consultation_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Odontogram_patientId_key" ON "Odontogram"("patientId");

-- AddForeignKey
ALTER TABLE "Consultation" ADD CONSTRAINT "Consultation_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
