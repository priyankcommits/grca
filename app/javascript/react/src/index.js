import { define } from 'remount'

import Home from './pages/Home/index.jsx'
import Admin from './pages/Admin/index.jsx'
import Book from './pages/Book/index.jsx'

define({ 'home-component': Home })
define({ 'admin-component': Admin })
define({ 'book-component': Book })
