class CreateBookEmbeddings < ActiveRecord::Migration[7.0]
  def change
    create_table :book_embeddings do |t|
      t.text :pages
      t.text :embeddings
      t.text :cover
      t.boolean :is_active, default: true
      t.string :status, default: 'pending'
      t.timestamps
    end
  end
end
