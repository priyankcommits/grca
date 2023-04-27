class BookEmbedding < ApplicationRecord
  attribute :embeddings, :text
  attribute :pages, :text
  belongs_to :book

  def self.create_book_embeddings(pages, embeddings, book_id)
    book_emb = BookEmbedding.new(pages: pages, embeddings: embeddings, book_id: book_id)
    book_emb.save
  end

  def self.get_book_embeddings(book_id)
    BookEmbedding.find_by(book_id: book_id)
  end
end
