class BookQuestion < ApplicationRecord
  attribute :display, :text
  attribute :content, :text
  attribute :ask_count, :integer, default: 1
  belongs_to :book

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

  def self.create_book_question(content)
    formatted_content = BookQuestion.formatted_content(content)
    book_question = BookQuestion.new
    book_question.display = content
    book_question.content = formatted_content
    book_question.save
  end

  def self.get_book_question(book_question_id)
    BookQuestion.where(id: book_question_id).first
  end

  def self.get_book_question_by_content(content)
    formatted_content = BookQuestion.formatted_content(content)
    BookQuestion.where(content: formatted_content).first
  end

  def self.update_ask_count(content)
    formatted_content = BookQuestion.formatted_content(content)
    book_question = BookQuestion.where(content: content).first
    if book_question.nil?
      book_question = BookQuestion.create_book_question(content)
    else
      book_question.ask_count += 1
      book_question.save
    end
  end

  def self.remove_least_asked_book_question
    book_question = BookQuestion.order(:ask_count, :created_at).first
    book_question.destroy
  end
end
