class Book < ApplicationRecord
  attribute :name, :string
  attribute :cover, :text
  attribute :is_active, :boolean, default: true
  attribute :status, :string, default: 'pending'
  has_one :book_embeddings
  has_many :book_questions

  def self.create_book(name, cover)
    book = Book.new(name: name, cover: cover)
    book.save
    return book
  end

  def self.get_book(book_id)
    Book.find(id: book_id)
  end

  def self.get_books
    Book.all
  end

  def self.get_books_for_users
    Book.where(is_active: true, status: 'processed')
  end

  def self.update_book_active(book_id, is_active)
    book = Book.find(id: book_id)
    book.update(is_active: is_active)
  end

  def self.update_book_status(book_id, status)
    book = Book.find(id: book_id)
    book.update(status: status)
  end
end
