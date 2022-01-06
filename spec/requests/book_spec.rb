require 'rails_helper'

RSpec.describe 'Books API', type: :request do

  # let!(:books) { FactoryBot.create_list(:book, 2) }
  # let(:book_id) { books.first.id }
  # FactoryBot.create(:book, title: 'New book', author: 'Habib')
  # FactoryBot.create(:book, title: 'Old book', author: 'Habib')

  describe 'GET /books' do
    let!(:books) { FactoryBot.create_list(:book, 2) }
    it 'should return all books' do
      get '/api/v1/books'

      expect(response).to have_http_status(:success)
      expect(json_res.size).eql?(2)
    end
  end

  describe 'GET /books/:id' do
    let!(:books) { FactoryBot.create_list(:book, 2) }
    let(:book_id) { books.first.id }
    before { get "/api/v1/books/#{book_id}" }

    context 'when book record exists' do
      it 'should return a book' do
        expect(json_res).not_to be_empty
        expect(json_res['id']).to eq(book_id)
      end

      it 'should return a success http status' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when book does not exists' do
      let(:book_id) { 10 }
      it 'should return not found http status' do
        expect(response).to have_http_status(:not_found)
      end
    end

  end

  describe 'POST /books' do
    let!(:books) { FactoryBot.create_list(:book, 2) }
    it 'should create new book' do
      expect do
        post '/api/v1/books', params: { title: 'Another great book', author: 'Habib' }
      end.to change { Book.count }.from(2).to(3)

      expect(response).to have_http_status(:created)
    end
  end

  describe 'PUT /books' do
    let!(:books) { FactoryBot.create_list(:book, 2) }
    let(:book_id) { books.first.id }
    before { put "/api/v1/books/#{book_id}", params: { title: 'Ruby on Rails', author: 'Habib' } }

    context 'when book id matched a book' do
      it 'should update book title and author record' do
        expect(json_res['title']).to match('Ruby on Rails')
        expect(json_res['author']).to match('Habib')
        expect(response).to have_http_status(:success)
      end
    end

    context 'when book id does not matched any book' do
      let(:book_id) { 8 }
      it 'should return http status not found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /books/:id' do
    let!(:books) { FactoryBot.create_list(:book, 2) }
    let(:book_id) { books.first.id }
    it 'should delete a book' do
      delete "/api/v1/books/#{book_id}"

      expect(Book.count).to eq(1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
