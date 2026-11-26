
const API_BASE_URL = '/api/v1'

function updateCsrfToken(token) {
  if (!token) return

  const csrfMetaTag = document.querySelector(
    'meta[name="csrf-token"]'
  )

  if (csrfMetaTag) {
    csrfMetaTag.content = token
  }
}

async function apiRequest(endpoint, options = {}) {
  const method = options.method || 'GET'

  const csrfToken = document.querySelector(
    'meta[name="csrf-token"]'
  )?.content

  const headers = {
    Accept: 'application/json',
    ...options.headers
  }

  if (options.body) {
    headers['Content-Type'] = 'application/json'
  }

  if (method !== 'GET' && csrfToken) {
    headers['X-CSRF-Token'] = csrfToken
  }

  const response = await fetch(
    `${API_BASE_URL}${endpoint}`,
    {
      ...options,
      method,
      headers,
      credentials: 'same-origin'
    }
  )

  const data = await response.json()

  // Rails generates a fresh CSRF token after session reset.
  updateCsrfToken(data.csrf_token)

  if (!response.ok) {
    throw new Error(data.error || 'Something went wrong')
  }

  return data
}

export function login(email, password) {
  return apiRequest('/login', {
    method: 'POST',
    body: JSON.stringify({ email, password })
  })
}

export function getCurrentUser() {
  return apiRequest('/me')
}

export function logout() {
  return apiRequest('/logout', {
    method: 'DELETE'
  })
}
