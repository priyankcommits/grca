import React, { useEffect, useState } from 'react'
import { Book, Toast, Spinner } from '../../components'
import { getUserBooks } from '../../api'

const Home = () => {
  const [toast, setToast] = useState([])
  const [books, setBooks] = useState([])
  const [state, setState] = useState({ loading: false })

  const getBooks = async () => {
    setState((ps) => ({ ...ps, loading: true }))
    try {
      const response = await getUserBooks()
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
      <div className="mt-5 grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-1 p-1">
        {books.map((book) => (
          <div className="w-full" key={book.id}>
            <Book type="user" book={book} />
          </div>
        ))}
      </div>
    </>
  )
}

export default Home
