require 'pdf-reader'
require 'numo/narray'

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
    reader = PDF::Reader.new(file.path)
    book = Book.create_book(book_name, cover_base64)
    book_id = book.id
    pages_text = []
    reader.pages.each do |page|
      pages_text << page.text
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

  def query_book
    book = Book.get_book(params[:id])
    query = params[:query]
    puts query
    puts book.id
    BookQuestion.question_asked(book.id, query)
    render :json => {:message => "Book queried successfully some text here man."}
    # wip
    # embeddings = JSON.parse(book.embeddings)
    # client = OpenAI::Client.new(
    #   access_token: ENV['OPENAI_API_KEY'],
    # )
    # Query the embedding using input text
    # input_embedding = client.embeddings(
    #   parameters: {
    #       model: "text-search-curie-query-001",
    #       input: query.split.take(2046)
    #   }
    # )
    # input = input_embedding["data"][0]["embedding"]
    # similarity_scores = []
    # embeddings.each do |embedding|
    #   score = (Numo::NArray[input] * (Numo::NArray[embedding])).sum
    #   similarity_scores << score
    # end
    # most_similar_index = similarity_scores.each_with_index.max[1]
    # puts most_similar_index
    end

    def query_book_lucky
      question = BookQuestion.get_question(params[:id])
      render :json => question
    end
end
