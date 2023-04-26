const BASE_URI = '/api/v1'

export const getBook = async (bookId) => {
  const response = await fetch(`${BASE_URI}/book?id=${bookId}`)
  const data = await response.json()
  return data
}

export const getAllBooks = async () => {
  const response = await fetch(`${BASE_URI}/books/admin`)
  const data = await response.json()
  return data
}

export const getUserBooks = async () => {
  const response = await fetch(`${BASE_URI}/books`)
  const data = await response.json()
  return data
}

export const createBook = async (book) => {
  const formData = new FormData()
  formData.append('name', book.name)
  if (book.cover) formData.append('cover', book.cover)
  formData.append('file', book.file)
  const response = await fetch(`${BASE_URI}/book`, {
    method: 'POST',
    body: formData,
  })
  const data = await response.json()
  return data
}

export const updateBookActive = async (bookId, isActive) => {
  const response = await fetch(`${BASE_URI}/book/${bookId}/active`, {
    method: 'PATCH',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ is_active: isActive }),
  })
  const data = await response.json()
  return data
}

export const updateBookStatus = async (bookId, status) => {
  const response = await fetch(`${BASE_URI}/book/${bookId}/active`, {
    method: 'PATCH',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ status: status }),
  })
  const data = await response.json()
  return data
}

export const askBook = async (bookId, query) => {
  const response = await fetch(`${BASE_URI}/book/${bookId}/query/ask`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ query: query }),
  })
  const data = await response.json()
  return data
}

export const askBookLucky = async (bookId) => {
  const response = await fetch(`${BASE_URI}/book/${bookId}/query/lucky`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
  })
  const data = await response.json()
  return data
}
