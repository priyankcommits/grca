require 'openai'

class BookProcessJob < ApplicationJob
  queue_as :urgent

  def perform(data)
    begin
      client = OpenAI::Client.new(
        access_token: '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'
      )
      # Extract text from the PDF
      embeddings = []
      data[:pages].each do |page|
        embedding = client.embeddings(
          parameters: {
              model: "text-search-curie-doc-001",
              input: page.split.take(2046).join(" ")
          }
        )
        puts embedding["data"][0]["embedding"].length
        embeddings << embedding["data"][0]["embedding"]
      end
      json_embeddings = embeddings.to_json
      json_pages = data[:pages].to_json
      book_id_integer = data[:book_id].to_i
      BookEmbedding.create_book_embeddings(json_pages, json_embeddings, book_id_integer)
    rescue => exception
      puts "Error"
      puts exception
    end
  end
end
