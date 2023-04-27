import React from 'react'

const Spinner = (props) => {
  const { loading } = props
  if (!loading) return null
  return (
    <>
      <div
        style={{ zIndex: 1000000 }}
        className="fixed top-0 inset-0 flex h-screen w-screen justify-center items-center"
      >
        <div className="flex justify-center items-center">
          <div className="animate-spin rounded-full h-16 w-16 border-t-2 border-b-2 border-yellow-500"></div>
        </div>
      </div>
      <div
        style={{ zIndex: 1000000 - 1 }}
        className="fixed bg-gray-700 bg-opacity-75 top-0 inset-0 flex h-screen w-screen"
      ></div>
    </>
  )
}

export default Spinner
