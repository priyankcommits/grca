# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_04_26_193639) do
  create_table "book_embeddings", force: :cascade do |t|
    t.text "pages"
    t.text "embeddings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "book_id"
    t.index ["book_id"], name: "index_book_embeddings_on_book_id"
  end

  create_table "book_questions", force: :cascade do |t|
    t.text "display"
    t.text "content"
    t.integer "ask_count", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "book_id"
    t.text "answer", default: "Sorry I don't know the answer to that question."
    t.index ["book_id"], name: "index_book_questions_on_book_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "name"
    t.text "cover"
    t.boolean "is_active", default: true
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "book_embeddings", "books"
  add_foreign_key "book_questions", "books"
end
