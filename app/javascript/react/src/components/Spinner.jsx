import React from 'react'

const Spinner = (props) => {
  const { loading } = props
  if (!loading) return null
  return (
    <>
      <div
        style={{ zIndex: 1000000 }}
        className="absolute inset-0 flex justify-center items-center"
      >
        <div className="flex justify-center items-center">
          <div className="animate-spin rounded-full h-16 w-16 border-t-2 border-b-2 border-yellow-500"></div>
        </div>
      </div>
      <div
        style={{ zIndex: 1000000 - 1, width: '100%', height: '100%' }}
        className="absolute bg-gray-700 bg-opacity-75"
      ></div>
    </>
  )
}

export default Spinner
