require 'openai'
require 'tokenizers'

class BookProcessJob < ApplicationJob
  queue_as :urgent

  def perform(data)
    book_id = data[:book_id].to_i
    begin
      client = OpenAI::Client.new(
        access_token: ENV['OPENAI_API_KEY'],
      )
      tokenizer = Tokenizers.from_pretrained("gpt2")
      # Extract text from the PDF
      embeddings = []
      data[:pages].each do |page|
        sleep 2
        embedding = client.embeddings(
          parameters: {
              model: "text-search-curie-doc-001",
              input: tokenizer.encode(page).tokens.take(2046).join(" ")
          }
        )
        # check if data is in embedding
        if embedding.key?("data")
          embeddings << embedding["data"][0]["embedding"]
        else
          embeddings << []
        end
      end
      json_embeddings = embeddings.to_json
      json_pages = data[:pages].to_json
      BookEmbedding.create_book_embeddings(json_pages, json_embeddings, book_id)
      Book.update_book_status(book_id, "processed")
    rescue => exception
      puts "Failed to get embeddings data due to #{exception.message}"
      Book.update_book_status(book_id, "error")
    end
  end
end
