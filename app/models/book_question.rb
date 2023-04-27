class BookQuestion < ApplicationRecord
  attribute :display, :text
  attribute :content, :text
  attribute :ask_count, :integer, default: 1
  attribute :answer, :text, default: "Sorry I don't know the answer to that question."
  belongs_to :book

  MAX_QUESTIONS = 100

  def self.get_question(book_id)
    question_count = BookQuestion.where(book_id: book_id).count
    random_index = rand(question_count)
    BookQuestion.where(book_id: book_id).offset(random_index).first
  end

  def self.question_asked(book_id, query)
    is_new_question = false
    book_question = BookQuestion.get_book_question_by_content(book_id, query)
    if book_question.nil?
      is_new_question = true
      book_question = BookQuestion.create_book_question(book_id, query)
    else
      book_question.ask_count += 1
      book_question.save
    end
    question_count = BookQuestion.where(book_id: book_id).count
    if question_count > BookQuestion::MAX_QUESTIONS
      BookQuestion.remove_least_asked_question(book_id)
    end
    return book_question, is_new_question
  end

  def self.create_book_question(book_id, content)
    formatted_content = BookQuestion.formatted_content(content)
    book_question = BookQuestion.new(display: content, content: formatted_content, book_id: book_id)
    book_question.save
    book_question
  end

  def self.get_book_question_by_content(book_id, content)
    formatted_content = BookQuestion.formatted_content(content)
    BookQuestion.where(book_id: book_id, content: formatted_content).first
  end

  def self.remove_least_asked_question(book_id)
    book_question = BookQuestion.find_by(book_id: book_id).order(:ask_count, :created_at).first
    book_question.destroy
  end

  private
  def self.formatted_content(content)
    # lower case content
    formatted_content = content.downcase
    # remove punctuation
    formatted_content = formatted_content.gsub(/[^0-9A-Za-z ]/, '')
    # remove extra spaces
    formatted_content = formatted_content.gsub(/\s+/, ' ')
    # remove leading and trailing spaces
    formatted_content = formatted_content.strip
    # remove question mark
    formatted_content = formatted_content.gsub(/\?/, '')
    formatted_content
  end
end
