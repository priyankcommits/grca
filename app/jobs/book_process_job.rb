require 'openai'
require 'tokenizers'

class BookProcessJob < ApplicationJob
  queue_as :urgent

  def perform(data)
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
      book_id_integer = data[:book_id].to_i
      BookEmbedding.create_book_embeddings(json_pages, json_embeddings, book_id_integer)
      Book.update_book_status(book_id_integer, "processed")
    rescue => exception
      puts "Error"
      puts exception
      Book.update_book_status(data[:book_id].to_i, "error")
    end
  end
end
