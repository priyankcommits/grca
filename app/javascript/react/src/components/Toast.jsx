import React, { useEffect, useState } from 'react'

const Toast = ({ message = 'Done', type = 'Success' }) => {
  const typeLower = type.toLowerCase()

  const classTypeMap = {
    success: 'bg-green-500',
    error: 'bg-red-500',
    warning: 'bg-yellow-500',
    info: 'bg-blue-500',
  }

  const toastTimeSeconds = 5
  const [toastTimer, setToastTimer] = useState(toastTimeSeconds)

  useEffect(() => {
    const timer =
      toastTimer > 0 && setInterval(() => setToastTimer(toastTimer - 1), 1000)
    return () => clearInterval(timer)
  }, [toastTimer])

  if (toastTimer === 0) return null
  return (
    <div className="fixed top-4 right-4">
      <div
        className={`${classTypeMap[typeLower]} text-white py-2 px-4 border border-black shadow-md`}
      >
        {message}
      </div>
    </div>
  )
}

export default Toast
