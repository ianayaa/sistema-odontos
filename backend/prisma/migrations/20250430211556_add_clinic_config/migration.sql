-- CreateTable
CREATE TABLE "ClinicConfig" (
    "id" TEXT NOT NULL,
    "nombreClinica" TEXT NOT NULL,
    "telefono" TEXT NOT NULL,
    "direccion" TEXT NOT NULL,
    "correo" TEXT NOT NULL,
    "horario" TEXT NOT NULL,
    "colorPrincipal" TEXT NOT NULL,
    "logoUrl" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ClinicConfig_pkey" PRIMARY KEY ("id")
);
