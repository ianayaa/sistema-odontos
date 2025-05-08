export interface User {
  id: string;
  email: string;
  name: string;
  lastNamePaterno: string;
  lastNameMaterno: string;
  role: 'ADMIN' | 'DENTIST' | 'ASSISTANT' | 'PATIENT';
  isActive: boolean;
  createdAt: string;
  permissions?: string[];
} 