import React, { useEffect, useState } from 'react'
import { Book, Spinner, Toast } from '../../components'
import { createBook, getAllBooks } from '../../api'

const Admin = () => {
  const [showModal, setShowModal] = useState(false)
  const [toast, setToast] = useState([])
  const [books, setBooks] = useState([])
  const initialState = {
    name: null,
    cover: null,
    coverName: null,
    file: null,
    error: null,
    loading: false,
  }
  const [state, setState] = useState(initialState)

  const getBooks = async () => {
    setState((ps) => ({ ...ps, loading: true }))
    try {
      const response = await getAllBooks()
      setBooks(response)
    } catch (error) {
      setToast([{ message: error, type: 'error' }])
    } finally {
      setState((ps) => ({ ...ps, loading: false }))
    }
  }

  useEffect(() => {
    getBooks()
    return () => {
      setBooks([])
      setToast([])
    }
  }, [])

  const handleSubmit = async () => {
    if (!state.name?.trim() || !state.file) {
      setState((ps) => ({
        ...ps,
        error: 'Please fill all the required fields',
      }))
      return
    }
    setState((ps) => ({ ...ps, loading: true }))
    try {
      const response = await createBook(state)
      setToast([{ message: response.message, type: 'success' }])
      setState({ ...initialState })
      setShowModal(false)
      getBooks()
    } catch (error) {
      setShowModal(false)
      setToast([{ message: error, type: 'error' }])
    } finally {
      setState((ps) => ({ ...ps, loading: false }))
    }
  }

  const onBookUpload = (e) => {
    if (!e.target.files[0]) return
    const file = e.target.files[0]
    setState((ps) => ({ ...ps, file }))
  }

  const onCoverUpload = (e) => {
    if (!e.target.files[0]) return
    const cover = e.target.files[0]
    const reader = new FileReader()
    reader.readAsDataURL(cover)
    reader.onload = () => {
      const coverBase64 = reader.result
      setState((ps) => ({ ...ps, cover: coverBase64, coverName: cover.name }))
    }
  }

  return (
    <>
      <Spinner loading={state.loading} />
      {toast.map((item, index) => (
        <Toast
          message={item.message}
          type={item.type}
          key={`${item.message}-${index}`}
        />
      ))}
      <button
        className="flex ml-2 mt-2 text-black bg-yellow-500 hover:bg-yellow-700 text-white font-bold py-2 px-4 border border-black"
        onClick={() => setShowModal(true)}
      >
        Add New Book
        <span>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            strokeWidth="1.5"
            stroke="currentColor"
            className="w-6 h-6"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M12 6v12m6-6H6"
            />
          </svg>
        </span>
      </button>
      <div className="mt-5 grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-1 p-1">
        {books.map((book) => (
          <div className="w-full" key={book.id}>
            <Book bookUpdated={getBooks} type="admin" book={book} />
          </div>
        ))}
      </div>
      {showModal && (
        <div
          id="modal-overlay"
          className="fixed inset-0 z-50 bg-gray-900 bg-opacity-75 flex items-center justify-center"
        >
          <div className="bg-white p-10 pt-4 max-w-md mx-auto overflow-y-auto">
            <h2 className="text-xl font-bold mb-4">Add New Book</h2>
            <div className="mb-4">
              <div>
                <label
                  htmlFor="name"
                  className="block text-gray-700 font-bold mb-2"
                >
                  Book Name
                  <span className="text-red-500">*</span>
                </label>
                <input
                  id="name"
                  type="text"
                  placeholder="Book Name"
                  className="w-full px-3 py-2 placeholder-gray-400 border border-black focus:outline-none focus:ring-2 focus:ring-yellow-400 focus:border-transparent"
                  onChange={(e) =>
                    setState((ps) => ({ ...ps, name: e.target.value }))
                  }
                />
              </div>
              <label
                htmlFor="file-upload"
                className="mt-2 block text-gray-700 font-bold mb-2"
              >
                Upload a PDF book
                <span className="text-red-500">*</span>
              </label>
              <div className="relative border-dashed border-2 border-gray-400 p-4 cursor-pointer">
                <input
                  id="file-upload"
                  type="file"
                  accept=".pdf"
                  className="absolute top-0 left-0 w-full h-full opacity-0"
                  onChange={onBookUpload}
                />
                <div className="text-center flex">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                    strokeWidth="1.5"
                    stroke="currentColor"
                    className="w-6 h-6"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m6.75 12l-3-3m0 0l-3 3m3-3v6m-1.5-15H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z"
                    />
                  </svg>

                  <p className="mt-1 text-sm text-gray-600">
                    Drag and drop or click to upload
                  </p>
                </div>
                {state.file && (
                  <p className="text-gray-500 text-sm  my-2 ml-1">
                    {state.file?.name}
                  </p>
                )}
              </div>
              <label
                htmlFor="file-upload"
                className="mt-2 block text-gray-700 font-bold mb-2"
              >
                Upload a cover for the book
              </label>
              <div className="relative border-dashed border-2 border-gray-400 p-4 cursor-pointer">
                <input
                  id="file-upload"
                  type="file"
                  accept=".png, .jpg, .jpeg"
                  className="absolute top-0 left-0 w-full h-full opacity-0"
                  onChange={onCoverUpload}
                />
                <div className="text-center flex">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                    strokeWidth="1.5"
                    stroke="currentColor"
                    className="w-6 h-6"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M2.25 15.75l5.159-5.159a2.25 2.25 0 013.182 0l5.159 5.159m-1.5-1.5l1.409-1.409a2.25 2.25 0 013.182 0l2.909 2.909m-18 3.75h16.5a1.5 1.5 0 001.5-1.5V6a1.5 1.5 0 00-1.5-1.5H3.75A1.5 1.5 0 002.25 6v12a1.5 1.5 0 001.5 1.5zm10.5-11.25h.008v.008h-.008V8.25zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0z"
                    />
                  </svg>

                  <p className="mt-1 text-sm text-gray-600">
                    Drag and drop or click to upload
                  </p>
                </div>
                {state.cover && (
                  <p className="text-gray-500 text-sm my-2 ml-1">
                    {state.coverName}
                  </p>
                )}
              </div>
            </div>
            {state.error && (
              <p className="text-red-500 text-sm my-4">{state.error}</p>
            )}
            <button
              className="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 border border-black"
              onClick={() => setShowModal(false)}
            >
              Close
            </button>
            <button
              className="ml-3 bg-yellow-500 hover:bg-yellow-700 text-white font-bold py-2 px-4 border border-black"
              onClick={handleSubmit}
            >
              Submit
            </button>
          </div>
        </div>
      )}
    </>
  )
}

export default Admin
