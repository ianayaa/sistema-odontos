/*
  Warnings:

  - You are about to drop the `Odontogram` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Odontogram" DROP CONSTRAINT "Odontogram_patientId_fkey";

-- DropTable
DROP TABLE "Odontogram";

-- CreateTable
CREATE TABLE "odontogram" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "data" JSONB NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "odontogram_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "odontogram_patientId_key" ON "odontogram"("patientId");

-- AddForeignKey
ALTER TABLE "odontogram" ADD CONSTRAINT "odontogram_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
