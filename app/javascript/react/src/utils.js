export const calculateTextThubmnail = (text) => {
  if (!text) return 'AA'
  const words = text.split(' ')
  if (words.length === 1) return `${words[0]}`.toUpperCase().slice(0, 2)
  return `${words[0].charAt(0)}${words[words.length - 1].charAt(
    0
  )}`.toUpperCase()
}
