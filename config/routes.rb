Rails.application.routes.draw do
  get 'book_embeddings/create'
  get 'book/create'
  get 'home/index'
  get 'home/about'
  post 'book/create'
  post 'book/query' => 'book#query_book'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end
