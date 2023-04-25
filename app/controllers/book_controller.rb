require 'pdf-reader'
require 'numo/narray'

OpenAI.configure do |config|
  config.access_token = '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'
end

class BookController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def create
    cover = params[:cover] if params[:cover].present? || nil
    file = params[:file] if params[:file].present? || nil
    book_name = params[:name]
    if cover
      cover_base64 = Base64.encode64(cover.read)
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

  def get_books
    books = Book.get_books
    render :json => books
  end

  def query_book
    book = Book.get_book(21)
    embeddings = JSON.parse(book.embeddings)
    query = params[:query]
    client = OpenAI::Client.new(
      access_token: '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'
    )
    # Query the embedding using input text
    input_embedding = client.embeddings(
      parameters: {
          model: "text-search-curie-query-001",
          input: query.split.take(2046)
      }
    )
    input = input_embedding["data"][0]["embedding"]
    similarity_scores = []
    embeddings.each do |embedding|
      score = (Numo::NArray[input] * (Numo::NArray[embedding])).sum
      similarity_scores << score
    end
    most_similar_index = similarity_scores.each_with_index.max[1]
    puts most_similar_index
    end
end
