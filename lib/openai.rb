require "openai"
require "tokenizers"

class OpenAiWrapper
  @@client = OpenAI::Client.new(
    access_token: ENV['OPENAI_API_KEY'],
  )
  @@tokenizer = Tokenizers.from_pretrained("gpt2")

  def create_embeddings(model, text)
    response = @@client.embeddings(
      parameters: {
        model: model,
        input: @@tokenizer.encode(text).tokens.take(2046).join(" ")
      }
    )
    return response
  end

  def create_completion(model, text, max_tokens)
    response = @@client.completions(
      parameters: {
        model: model,
        prompt: text,
        temperature: 0.0,
        max_tokens: max_tokens
      }
    )
    return response
  end
end
