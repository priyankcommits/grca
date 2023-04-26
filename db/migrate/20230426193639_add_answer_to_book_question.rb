class AddAnswerToBookQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :book_questions, :answer, :text, default: "Sorry I don't know the answer to that question."
  end
end
