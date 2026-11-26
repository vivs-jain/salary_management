
import React from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'

function Dashboard() {
  const { user, signOut } = useAuth()
  const navigate = useNavigate()

  const handleLogout = async () => {
    try {
      await signOut()

      navigate('/login', { replace: true })
    } catch (error) {
      alert('Unable to logout. Please try again.')
    }
  }

  return (
    <div className="container py-5">

      <div className="d-flex justify-content-between align-items-center mb-4">

        <h2>Salary Management</h2>

        <button
          className="btn btn-outline-danger"
          onClick={handleLogout}
        >
          Logout
        </button>

      </div>

      <div className="card shadow-sm">
        <div className="card-body p-4">

          <h3>Welcome to Dashboard</h3>

          <p className="text-muted mt-3">
            You have successfully logged in.
          </p>

          <hr />

          <h5>Logged-in User Details</h5>

          <p>
            <strong>Name:</strong>{' '}
            {user.first_name} {user.last_name}
          </p>

          <p>
            <strong>Email:</strong>{' '}
            {user.email}
          </p>

        </div>
      </div>

    </div>
  )
}

export default Dashboard
