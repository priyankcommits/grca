class Book < ApplicationRecord
  attribute :name, :string
  attribute :cover, :text
  attribute :is_active, :boolean, default: true
  attribute :status, :string, default: 'pending'
  has_many :book_embeddings
  has_many :book_questions

  def self.create_book(name, cover)
    book = Book.new
    book.name = name
    book.cover = cover
    book.save
    return book
  end

  def self.get_books
    Book.all
  end

  def self.get_book(book_id)
    Book.where(id: book_id).first
  end
end
