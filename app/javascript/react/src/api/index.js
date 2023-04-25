export const getAllBooks = async () => {
  const response = await fetch('/books')
  const data = await response.json()
  return data
}

export const createBook = async (book) => {
  const formData = new FormData()
  formData.append('name', book.name)
  if (book.cover) formData.append('cover', book.cover)
  formData.append('file', book.file)
  const response = await fetch('/book', {
    method: 'POST',
    body: formData,
  })
  const data = await response.json()
  return data
}
