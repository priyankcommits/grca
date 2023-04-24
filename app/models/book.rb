class Book < ApplicationRecord
  attribute :name, :string
  attribute :embeddings, :text

  def self.create_book(name, embeddings)
    book = Book.new
    book.name = name
    book.embeddings = embeddings
    book.save
  end

  def self.get_book(book_id)
    Book.where(id: book_id).first
  end
end
