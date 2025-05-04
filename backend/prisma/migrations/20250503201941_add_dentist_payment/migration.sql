-- CreateTable
CREATE TABLE "DentistPayment" (
    "id" TEXT NOT NULL,
    "dentistId" TEXT NOT NULL,
    "period" TEXT NOT NULL,
    "baseSalary" DOUBLE PRECISION NOT NULL,
    "commission" DOUBLE PRECISION NOT NULL,
    "deductions" DOUBLE PRECISION NOT NULL,
    "total" DOUBLE PRECISION NOT NULL,
    "status" TEXT NOT NULL,
    "paymentDate" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DentistPayment_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "DentistPayment" ADD CONSTRAINT "DentistPayment_dentistId_fkey" FOREIGN KEY ("dentistId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
