Rails.application.routes.draw do
  get 'admin' => 'admin#index'
  get 'home/index'
  get 'book' => 'book#book'
  get 'api/v1/book' => 'book#get_book'
  get 'api/v1/books/admin' => 'book#get_books'
  get 'api/v1/books' => 'book#get_books_for_users'
  patch 'api/v1/book/:id/status' => 'book#update_book_status'
  patch 'api/v1/book/:id/active' => 'book#update_book_active'
  post 'api/v1/book' => 'book#create'
  post 'api/v1/book/:id/query/ask' => 'book#query_book'
  post 'api/v1/book/:id/query/lucky' => 'book#query_book_lucky'

  root "home#index"
end
