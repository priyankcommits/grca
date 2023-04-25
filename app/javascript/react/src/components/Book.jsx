import React from 'react'

const Book = () => {
  return (
    <div className="rounded-lg border border-black">
      <img
        className="rounded-t-lg w-full h-auto"
        src="https://via.placeholder.com/300"
        alt="Image"
      />
      <div className="p-2">
        <h3 className="text-lg font-bold">Book Title</h3>
        <p className="text-sm">Author</p>
        <p className="text-sm">Publisher</p>
        <p className="text-sm">Year</p>
      </div>
    </div>
  )
}

export default Book
