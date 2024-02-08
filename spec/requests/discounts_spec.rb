require 'rails_helper'

RSpec.describe DiscountsController, type: :controller do
  describe 'GET #calculate' do

    it 'returns a discount based on purchase count' do
      product = create(:product, price: 110, category_id: 2)
      user = create(:user, purchase_count: 3)
    
      get :calculate, params: { product_id: product.id, user_token: user.token }
    
      expect(response).to have_http_status(:ok)
    
      response_json = JSON.parse(response.body)
    
      expect(response_json['final_price']).to eq(104.5)
      expect(response_json['discount_perc']).to eq(5)
    end

    it 'returns a discount based on price exceeds 120' do
      product = create(:product, price: 130, category_id: 2)
      user = create(:user, purchase_count: 2)
    
      get :calculate, params: { product_id: product.id, user_token: user.token }
    
      expect(response).to have_http_status(:ok)
    
      response_json = JSON.parse(response.body)
    
      expect(response_json['final_price']).to eq(110.5)
      expect(response_json['discount_perc']).to eq(15)
    end

    it 'returns a discount based specific category' do
      product = create(:product, price: 110, category_id: 1)
      user = create(:user, purchase_count: 2)
    
      get :calculate, params: { product_id: product.id, user_token: user.token }
    
      expect(response).to have_http_status(:ok)
    
      response_json = JSON.parse(response.body)
    
      expect(response_json['final_price']).to eq(99.0)
      expect(response_json['discount_perc']).to eq(10)
    end

    it 'returns a discount based on multiple discounts' do
      product = create(:product, price: 150, category_id: 1)
      user = create(:user, purchase_count: 3)
    
      get :calculate, params: { product_id: product.id, user_token: user.token }
    
      expect(response).to have_http_status(:ok)
    
      response_json = JSON.parse(response.body)
    
      expect(response_json['final_price']).to eq(105.0)
      expect(response_json['discount_perc']).to eq(30)
    end

    it 'returns a 0 discount if no criteria match' do
      product = create(:product, price: 100, category_id: 2)
      user = create(:user, purchase_count: 1)
    
      get :calculate, params: { product_id: product.id, user_token: user.token }
    
      expect(response).to have_http_status(:ok)
    
      response_json = JSON.parse(response.body)
    
      expect(response_json['final_price']).to eq(100.0)
      expect(response_json['discount_perc']).to eq(0)
    end

    it 'returns an error for an invalid product' do
      user = create(:user, purchase_count: 3)

      get :calculate, params: { product_id: 'invalid_id', user_token: user.token }

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include('Product or user not found')
    end

    it 'returns an error for an invalid user' do
      product = create(:product, price: 150)

      get :calculate, params: { product_id: product.id, user_token: 'invalid_token' }

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include('Product or user not found')
    end
  end
end