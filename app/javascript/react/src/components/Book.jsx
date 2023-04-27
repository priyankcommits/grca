import React, { useState } from 'react'
import { Spinner, Toast } from '../components'
import { darkColorHexesRepeated } from '../constants'
import { calculateTextThubmnail } from '../utils'
import { updateBookActive } from '../api'

const Book = (props) => {
  const { book, type = 'user', bookUpdated = () => {} } = props
  const [toast, setToast] = useState([])
  const [state, setState] = useState({ loading: false })

  const charCode = book.name.charCodeAt(0)
  const bgColor = darkColorHexesRepeated[charCode] || '#000000'

  const updateStatus = async () => {
    if (type !== 'admin') return
    setState((ps) => ({ ...ps, loading: true }))
    try {
      await updateBookActive(book.id, !book.is_active)
      bookUpdated()
      setToast([{ message: 'Updated book status.', type: 'success' }])
    } catch (error) {
      setToast([{ message: error, type: 'error' }])
    } finally {
      setState((ps) => ({ ...ps, loading: false }))
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
      <div className="border border-black">
        <a href={`/book?id=${book.id}`}>
          {book.cover && (
            <img
              className="w-full h-auto"
              src={`${book.cover}`}
              alt="Book Cover"
              style={{ height: '300px', objectFit: 'cover' }}
            />
          )}
          {!book.cover && (
            <div
              style={{ height: '300px', objectFit: 'cover' }}
              className="bg-gray-200 flex items-center justify-center text-black text-3xl font-bold"
            >
              {calculateTextThubmnail(book.name)}
            </div>
          )}
        </a>
        <div style={{ backgroundColor: bgColor }} className="p-2">
          <h3 className="text-md font-bold text-white capitalize">
            <a href={`/book?id=${book.id}`}>{book.name}</a>
          </h3>
          {type === 'admin' && (
            <div className="flex">
              <div className="p-1 px-2 rounded-full border border-black bg-white text-black capitalize">
                Processing: {book.status}
              </div>
              <button onClick={updateStatus}>
                <div className="ml-4 p-1 px-2 rounded-full border border-black bg-white text-black">
                  Public: {book.is_active ? 'Active' : 'Inactive'}
                </div>
              </button>
            </div>
          )}
        </div>
      </div>
    </>
  )
}

export default Book
