class AddBookForeignKeys < ActiveRecord::Migration[7.0]
  def change
    add_reference :book_embeddings, :book, foreign_key: true
    add_reference :book_questions, :book, foreign_key: true
  end
end
