require 'pdf-reader'
require 'openai'
require 'numo/narray'

OpenAI.configure do |config|
  config.access_token = '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'
end

class BookController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def create
    file = params[:file]
    book_name = params[:name]
    puts file.path
    puts book_name
    reader = PDF::Reader.new(file.path)

    client = OpenAI::Client.new(
      access_token: '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'
    )
    # Extract text from the PDF
    embeddings = []
    reader.pages.each do |page|
      puts page.text.split.take(2046).join(" ")
      embedding = client.embeddings(
        parameters: {
            model: "text-search-curie-doc-001",
            input: page.text.split.take(2046).join(" ")
        }
      )
      puts embedding["data"][0]["embedding"].length
      embeddings << embedding["data"][0]["embedding"]
    end
    json_embeddings = embeddings.to_json
    Book.create_book(book_name, json_embeddings)
    msg = {:status => "success", :message => "Book uploaded successfully, now processing."}
    render :json => msg
  end

  def query_book
    book = Book.get_book(21)
    embeddings = JSON.parse(book.embeddings)
    query = params[:query]
    puts book.name
    puts query
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
    puts embeddings.length
    embeddings.each do |embedding|
      score = (Numo::NArray[input] * (Numo::NArray[embedding])).sum
      similarity_scores << score
    end
    most_similar_index = similarity_scores.each_with_index.max[1]
    puts most_similar_index
    end
end
