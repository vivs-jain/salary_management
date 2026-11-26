
import React, {
  createContext,
  useContext,
  useEffect,
  useState
} from 'react'

import {
  login,
  getCurrentUser,
  logout
} from '../services/authService'

const AuthContext = createContext(null)

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)

  // Check existing Rails session when application starts.
  useEffect(() => {
    let mounted = true

    const checkSession = async () => {
      try {
        const response = await getCurrentUser()

        if (mounted) {
          setUser(response.user)
        }
      } catch (error) {
        if (mounted) {
          setUser(null)
        }
      } finally {
        if (mounted) {
          setLoading(false)
        }
      }
    }

    checkSession()

    return () => {
      mounted = false
    }
  }, [])

  // Login
  const signIn = async (email, password) => {
    const response = await login(email, password)

    setUser(response.user)

    return response.user
  }

  // Logout
  const signOut = async () => {
    await logout()
    setUser(null)
  }

  return (
    <AuthContext.Provider
      value={{
        user,
        loading,
        signIn,
        signOut
      }}
    >
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const context = useContext(AuthContext)

  if (!context) {
    throw new Error(
      'useAuth must be used within AuthProvider'
    )
  }

  return context
}
