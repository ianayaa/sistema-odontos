-- CreateTable
CREATE TABLE "DentistSchedule" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "workingDays" JSONB NOT NULL,
    "startTime" TEXT NOT NULL,
    "endTime" TEXT NOT NULL,
    "blockedHours" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DentistSchedule_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "DentistSchedule_userId_key" ON "DentistSchedule"("userId");

-- AddForeignKey
ALTER TABLE "DentistSchedule" ADD CONSTRAINT "DentistSchedule_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
