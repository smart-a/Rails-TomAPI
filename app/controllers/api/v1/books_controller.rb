module Api
  module V1
    class BooksController < ApplicationController
      before_action :find_book, only: %i[show update]

      def index
        books = Book.all
        json_response(BooksRepresenter.new(books).as_json)
      end

      def show
        json_response(@book)
      end

      def create
        book = Book.create(book_params)

        if book.save
          json_response(book, :created)
        else
          json_response(book.errors, :unprocessable_entity)
        end
      end

      def update
        @book.update(book_params)
        json_response(@book)
      end

      def destroy
        Book.find(params[:id]).delete
        json_response({ message: 'book destroyed!' }, :no_content)
      end



      private

      # @return [Book]
      def find_book
        @book = Book.find(params[:id])
      end

      def book_params
        params.permit(:title, :author)
      end
    end
  end
end
