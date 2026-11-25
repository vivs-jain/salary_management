
import React from 'react'
import { BrowserRouter, Routes, Route } from 'react-router-dom'

function Home() {
  return (
    <div className="container py-5">
      <div className="card shadow-sm">
        <div className="card-body p-5 text-center">
          <h1 className="text-primary">
            Salary Management
          </h1>

          <p className="text-muted mt-3">
            Welcome to the Salary Management System.
          </p>

          <span className="badge bg-success">
            React + Rails integration successful
          </span>
        </div>
      </div>
    </div>
  )
}

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
      </Routes>
    </BrowserRouter>
  )
}

export default App
