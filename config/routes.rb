Rails.application.routes.draw do
  get 'admin' => 'admin#index'

  get 'home/index'

  get 'books' => 'book#book'

  get 'api/v1/books' => 'book#get_book'
  get 'api/v1/books/admin' => 'book#get_books'
  get 'api/v1/books/user' => 'book#get_books_for_users'
  patch 'api/v1/books/:id/status' => 'book#update_book_status'
  patch 'api/v1/books/:id/active' => 'book#update_book_active'
  post 'api/v1/books' => 'book#create'
  post 'api/v1/books/:id/query/ask' => 'book#ask_query_book'
  post 'api/v1/books/:id/query/lucky' => 'book#lucky_query_book'

  root "home#index"
end
