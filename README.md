# Welcome to GRCA!

Hi! **GRCA** is done as a coding assignment.


# Environment

- Ruby 3.1.4
- Rails 7.0.4
- Managed using RVM, Gem, Bundle tools
- Notable Libraries: **Ruby-OpenAI**, **Tokenizers**, **PDF Reader**, **PG**
- Web Server: **PUMA**
- Front End: **React** using [remount](https://www.npmjs.com/package/remount)
- Front End: Hosted within Rails works in Multi page style
- Database: **Postgres**
- Hosted on: **Heroku**

## Usage

On the home page landing the processed and active books show up. To add a new Book click on the `Admin Portal` link and upload a new book. This will start a background job to process the book, meaning creating embeddings on a page-by-page basis. Roughly will take `(number of pages * 3 seconds)`. You can upload an optional cover image for the book. You can enable or disable the book using the admin portal as well by clicking on the `Active` badge.
Initially, the book will show up as `Processing` and if successful will turn into `Processed`. Once `Processed` you can click on the book and start asking it questions.
It has two modes, `Ask` is for asking a question by typing, `Feeling lucky` is to pick a frequently asked question on a random basis. If a question is asked previously it will load from local DB instead of hitting the OpenAI servers (top 100 are stored for each book).

## Architecture

 - Front End: React Hosted within Rails app on a component per page basis. The `pages` are defined in the source code [here](https://github.com/priyankcommits/grca/tree/main/app/javascript/react/src/pages) and it's invoked in [this](https://github.com/priyankcommits/grca/blob/main/app/views/book/book.html.erb) fashion
 - Front End: Uses Tailwind for styling aspects
 - Front End: Uses prettier for auto formatting code
 - Front End: Styling lingo copied from a popular site
 - Front End: Is mobile responsive
 - API: Uses Rails `ActiveRecord` as ORM
 - API: Uses Rails Jobs to run background async jobs, when a book is uploaded
 - API: Uses Postgres as the data store including the PDF pages and embeddings
 - API: Embeddings are calculated using OpenAI `curie` model
 - API: Tokenizing is done using `gpt2` pre trained tokenizer
 - API: Completion is performed using OpenAI `davinci` model
 - API: **Postman** collection is included in the repository for easy API reference [here](https://github.com/priyankcommits/grca/blob/main/Dev.postman_collection.json)

## Improvement thoughts

 - Front End: **Jest** tests, story book integration.
 - Front End: Use linting using `Eslint`
 - Front End: Add Authentication n Authorization for a serious app
 - Front End: Use a component based framework like `AntD` or `Material`
 - Front End: Add appropriate SEO tags where needed
 - API: Use Validators at controller level for required params
 - API: Use some validations at Middleware like `csrf` token
 - API: Tests using **RSpec**
 - API: Handle failure cases with more grace at certain places
 - API: Use `4xx`, `5xx`
 - API: Use something like **AWS S3** for storing book cover
 - API: Use something like **VectorDB** to store the embeddings
 - API: More usage of `begin / rescue` and better exception handling
 - API: Robust logging
 - API: DB audit logging when any object changes or updates
 - API: Paranoid deleting
 - CI/CD: Run test suite
 - CI/CD: Alerting when build fails

## Contact / Feedback

Feel free to reach me at, or give feedback or improvements.

> **Message me at:** `pulumati.priyank@gmail.com`
