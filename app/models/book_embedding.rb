class BookEmbedding < ApplicationRecord
  attribute :embeddings, :text
  attribute :pages, :text
  belongs_to :book

  def self.create_book_embeddings(pages, embeddings, book_id)
    book_emb = BookEmbedding.new
    book_emb.pages = pages
    book_emb.embeddings = embeddings
    book_emb.book_id = book_id
    book_emb.save
  end

  def self.get_book_emb(book_id)
    BookEmbedding.where(book_id: book_id).first
  end
end
