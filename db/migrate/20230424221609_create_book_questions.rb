class CreateBookQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :book_questions do |t|
      t.text :display
      t.text :content
      t.integer :ask_count, default: 1
      t.timestamps
    end
  end
end
