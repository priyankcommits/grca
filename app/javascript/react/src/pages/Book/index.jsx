import React, { useEffect, useState } from 'react'
import { Spinner } from '../../components'
import { darkColorHexesRepeated } from '../../constants'
import { getBook, askBook, askBookLucky } from '../../api'
import { calculateTextThubmnail } from '../../utils'

const Book = () => {
  const [book, setBook] = useState({})
  const [state, setState] = useState({
    loading: false,
    queryText: '',
    answer: null,
  })
  const [showAnswer, setShowAnswer] = useState(false)
  const [formattedAnswer, setFormattedAnswer] = useState([])

  const queryParmas = new URLSearchParams(window.location.search)
  let charCode = book?.name?.charCodeAt(0) || null
  let bgColor = charCode ? darkColorHexesRepeated[charCode] : null

  const getBookDetails = async () => {
    try {
      const response = await getBook(queryParmas.get('id'))
      setBook(response)
    } catch (error) {
      console.log(error)
    }
  }
  useEffect(() => {
    getBookDetails()
    return () => {
      setBook({})
    }
  }, [])

  useEffect(() => {
    if (!showAnswer) return
    const wordsInAnswer = state.answer.split(' ')
    let wordIndex = 0
    const interval = setInterval(() => {
      if (wordIndex === wordsInAnswer.length) {
        clearInterval(interval)
        return
      }
      setFormattedAnswer((ps) => {
        const newWords = [...ps, wordsInAnswer[wordIndex]]
        return newWords
      })
      wordIndex++
    }, 200)
    return () => {
      clearInterval(interval)
    }
  }, [showAnswer])

  const ask = async () => {
    setShowAnswer(false)
    setFormattedAnswer([])
    setState((ps) => ({ ...ps, loading: true }))
    try {
      const response = await askBook(book.id, state.queryText)
      setState((ps) => ({ ...ps, answer: response.message }))
      setShowAnswer(true)
      try {
        speechSynthesis.speak(new SpeechSynthesisUtterance(response.message))
      } catch (error) {
        console.log(error)
      }
    } catch (error) {
      console.log(error)
    } finally {
      setState((ps) => ({ ...ps, loading: false }))
    }
  }

  const lucky = async () => {
    setShowAnswer(false)
    setFormattedAnswer([])
    setState((ps) => ({ ...ps, loading: true }))
    try {
      const response = await askBookLucky(book.id, state.queryText)
      setState((ps) => ({
        ...ps,
        answer: response?.answer,
        queryText: response?.display,
      }))
      setShowAnswer(true)
      try {
        speechSynthesis.speak(new SpeechSynthesisUtterance(response?.answer))
      } catch (error) {
        console.log(error)
      }
    } catch (error) {
      console.log(error)
    } finally {
      setState((ps) => ({ ...ps, loading: false }))
    }
  }

  if (!book?.id) return <Spinner loading={true} />

  return (
    <>
      <Spinner loading={state.loading} />
      <div className="flex flex-wrap">
        <div
          style={{ backgroundColor: bgColor, height: 'calc(100vh - 60px)' }}
          className="border-l border-r border-b border-black p-2 w-full md:w-1/2 flex justify-center items-center"
        >
          {book.cover && (
            <img
              src={book.cover}
              alt={book.name}
              style={{ objectFit: 'cover' }}
              className="h-auto"
            />
          )}
          {!book.cover && (
            <div className="flex items-center justify-center text-black text-3xl font-bold">
              {calculateTextThubmnail(book.name)}
            </div>
          )}
        </div>
        <div className="px-2 w-full md:w-1/2 my-2 md:my-1">
          <h1 className="text-black text-3xl">
            Ask us anything about {book.name} and we'll try to answer it!
          </h1>
          <textarea
            value={state.queryText}
            onChange={(e) => setState({ ...state, queryText: e.target.value })}
            maxLength={1000}
            className="mt-3 w-full h-64 focus:outline-none focus:ring-2 focus:ring-yellow-400 focus:border-transparent"
          />
          <button
            onClick={ask}
            className="bg-yellow-500 hover:bg-yellow-700 text-white font-bold py-2 px-4 mt-2"
          >
            Ask
          </button>
          <button
            onClick={lucky}
            className="ml-4 bg-black hover:bg-black text-white font-bold py-2 px-4 mt-2"
          >
            Feeling lucky
          </button>
          {showAnswer && (
            <div className="border border-black p-2 mt-2 md:mt-5 text-black">
              {formattedAnswer.join(' ')}
            </div>
          )}
        </div>
      </div>
    </>
  )
}

export default Book
