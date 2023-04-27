require 'pdf-reader'
require 'numo/narray'
require 'tokenizers'

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

  def query_book
    book = Book.get_book(params[:id])
    query = params[:query]
    unless query[-1] == '?'
      query += '?'
    end
    book_embeddings = BookEmbedding.get_book_emb(book.id)
    embeddings = JSON.parse(book_embeddings.embeddings)
    book_question, is_new_question = BookQuestion.question_asked(book.id, query)
    unless is_new_question
      return render :json => {:answer => book_question.answer }
    end
    client = OpenAI::Client.new(
      access_token: ENV['OPENAI_API_KEY'],
    )
    tokenizer = Tokenizers.from_pretrained("gpt2")
    # Query the embedding using input text
    input_embedding = client.embeddings(
      parameters: {
          model: "text-search-curie-query-001",
          input: tokenizer.encode(query).tokens.take(2046).join(" ")
      }
    )
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

    max_bytes = 4090 - query_length
    truncated_page_text = pages_text[0..max_bytes]

    answer = client.completions(
      parameters: {
        model: "text-davinci-003",
        prompt: truncated_page_text + "." + query,
        temperature: 0.0,
        max_tokens: [max_bytes, 2000].min,
      }
    )
    if answer.key?("error")
      render :json => {:answer => "Sorry, I don't know the answer to that question." }
    else
      answer = answer["choices"][0]["text"]
      answer = answer.gsub("\n", " ")
      answer = answer.gsub("b. ", " ")
      answer = answer.strip
      book_question.update(answer: answer)
      render :json => {:answer => answer }
    end
  end

    def query_book_lucky
      question = BookQuestion.get_question(params[:id])
      render :json => question
    end
end
