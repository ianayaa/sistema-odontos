import React from 'react';
import { render, screen } from '@testing-library/react';
import App from './App';
jest.mock('axios');

test('muestra el botón Iniciar sesión', async () => {
  render(<App />);
  const loginButton = await screen.findByRole('button', { name: /iniciar sesión/i });
  expect(loginButton).toBeInTheDocument();
});
