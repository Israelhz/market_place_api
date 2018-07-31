require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  describe "GET #index" do
    before(:each) do
      current_user = create :user
      api_authorization_header current_user.auth_token
      4.times { create :order, user: current_user }
      create :order
      get :index, params: { user_id: current_user.id }
    end

    it "returns 4 order records from the user" do
      orders_response = json_response
      expect(orders_response.count).to eq 4
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      current_user = create :user
      api_authorization_header current_user.auth_token

      @product = create :product
      @order = create :order, user: current_user, product_ids: [@product.id]
      get :show, params: { user_id: current_user.id, id: @order.id }
    end

    it "returns the user order record matching the id" do
      order_response = json_response
      expect(order_response[:id]).to eql @order.id
    end

    it "includes the total for the order" do
      order_response = json_response
      expect(order_response[:total]).to eql @order.total
    end

    it "includes the products on the order" do
      order_response = json_response
      expect(order_response[:products].count).to eq 1
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    before(:each) do
      current_user = create :user
      api_authorization_header current_user.auth_token

      product_1 = create :product
      product_2 = create :product
      order_params = { product_ids_and_quantities: [[product_1.id, 2],[ product_2.id, 3]] }
      post :create, params: { user_id: current_user.id, order: order_params }
    end

    it "returns just user order record" do
      order_response = json_response
      expect(order_response[:id]).to be_present
    end

    it "embeds the two product objects related to the order" do
      order_response = json_response
      expect(order_response[:products].size).to eql 2
    end

    it { should respond_with 201 }
  end
end
