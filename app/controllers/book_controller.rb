require 'pdf-reader'
require 'numo/narray'
require_relative "../../lib/openai"

class BookController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def create
    cover = params[:cover] if params[:cover].present? || nil
    file = params[:file] if params[:file].present? || nil
    book_name = params[:name]
    if cover
      cover_base64 = cover
    else
      cover_base64 = nil
    end
    pages_text = []
    begin
      reader = PDF::Reader.new(file.path)
      book = Book.create_book(book_name, cover_base64)
      book_id = book.id
      reader.pages.each do |page|
        pages_text << page.text
      end
    rescue => exception
      return render :json => {:message => "Error reading PDF file."}, status: :not_found
    end
    data = {:book_id => book_id, :pages => pages_text }
    BookProcessJob.perform_later data
    render :json => {:message => "Book uploaded successfully, now processing.", :book_id => book_id }
  end

  def book
  end

  def get_book
    book_id = params[:id]
    book = Book.get_book(book_id)
    render :json => book
  end

  def get_books
    books = Book.get_books
    render :json => books
  end

  def get_books_for_users
    books = Book.get_books_for_users
    render :json => books
  end

  def update_book_status
    book_id = params[:id]
    status = params[:status]
    book = Book.update_book_status(book_id, status)
    render :json => book
  end

  def update_book_active
    book_id = params[:id]
    is_active = params[:is_active]
    book = Book.update_book_active(book_id, is_active)
    render :json => book
  end

  def ask_query_book
    book = Book.get_book(params[:id])
    query = params[:query]
    unless query[-1] == '?'
      query += '?'
    end
    book_embeddings = BookEmbedding.get_book_embeddings(book.id)
    embeddings = JSON.parse(book_embeddings.embeddings)
    book_question, is_new_question = BookQuestion.question_asked(book.id, query)
    unless is_new_question
      return render :json => {:answer => book_question.answer }
    end

    openai_wrapper = OpenAiWrapper.new

    # Query the embedding using input text
    input_embedding = openai_wrapper.create_embeddings("text-search-curie-query-001", query)
    input = input_embedding["data"][0]["embedding"]

    similarity_scores = []
    embeddings.each do |embedding|
      if embedding.length != 4096
        similarity_scores << 0
        next
      end
      score = (Numo::NArray[input] * (Numo::NArray[embedding])).sum
      similarity_scores << score
    end

    pages = JSON.parse(book_embeddings.pages)
    # order pages based on similarity score index
    similarity_scores = similarity_scores.map.with_index.sort.map(&:last)
    # reverse the order
    similarity_scores = similarity_scores.reverse
    # get the pages in the order of similarity scores
    pages = pages.values_at(*similarity_scores)
    pages_text = pages.join(" ")

    query_length = query.bytesize

    max_bytes = 2000 - query_length
    truncated_page_text = pages_text[0..max_bytes]
    answer = openai_wrapper.create_completion(
      "text-search-curie-doc-001",
      truncated_page_text + "." + query,
      [max_bytes, 500].min,
    )
    standard_answer = "Sorry, I don't know the answer to that question."
    if answer.key?("error")
      return render :json => {:answer => standard_answer }
    else
      answer = answer["choices"][0]["text"]
      answer = answer.gsub("\n", " ")
      answer = answer.gsub("b. ", " ")
      answer = answer.strip
      book_question.update(answer: answer)
      if answer == ""
        answer = standard_answer
      end
      render :json => {:answer => answer }
    end
  end

  def lucky_query_book
    question = BookQuestion.get_question(params[:id])
    render :json => question
  end
end
