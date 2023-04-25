class CreateBookEmbeddings < ActiveRecord::Migration[7.0]
  def change
    create_table :book_embeddings do |t|
      t.text :pages
      t.text :embeddings
      t.timestamps
    end
  end
end
