
import React from 'react'
import {
  BrowserRouter,
  Routes,
  Route,
  Navigate
} from 'react-router-dom'

import { AuthProvider } from './contexts/AuthContext'

import Login from './pages/Login'
import Dashboard from './pages/Dashboard'

import ProtectedRoute from './routes/ProtectedRoute'
import GuestRoute from './routes/GuestRoute'

function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>

          {/* Public route */}
          <Route
            path="/login"
            element={
              <GuestRoute>
                <Login />
              </GuestRoute>
            }
          />

          {/* Protected routes */}
          <Route element={<ProtectedRoute />}>
            <Route
              path="/dashboard"
              element={<Dashboard />}
            />
          </Route>

          {/* Default route */}
          <Route
            path="/"
            element={<Navigate to="/dashboard" replace />}
          />

        </Routes>
      </AuthProvider>
    </BrowserRouter>
  )
}

export default App
