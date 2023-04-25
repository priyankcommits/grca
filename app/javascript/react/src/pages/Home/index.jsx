import * as React from 'react'
import Book from '../../components/Book'

const Home = () => {
  return (
    <div className="mt-5 grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-1 p-1">
      <div className="w-full">
        <Book />
      </div>
      <div className="w-full">
        <Book />
      </div>
      <div className="w-full">
        <Book />
      </div>
      <div className="w-full">
        <Book />
      </div>
      <div className="w-full">
        <Book />
      </div>
      <div className="w-full">
        <Book />
      </div>
      <div className="w-full">
        <Book />
      </div>
    </div>
  )
}

export default Home
