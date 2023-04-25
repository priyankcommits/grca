Rails.application.routes.draw do
  get 'admin' => 'admin#index'
  get 'home/index'
  get 'home/about'
  get 'book_embeddings/create'
  get 'books' => 'book#get_books'
  get 'book/create'
  post 'book' => 'book#create'
  post 'book/query' => 'book#query_book'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end
