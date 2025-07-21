require 'rails_helper'

RSpec.describe "Orders", type: :request do
  describe "GET /orders" do
    it "returns http success" do
      get "/orders"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/orders/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /orders" do
    it "creates a new order and redirects" do
      post "/orders", params: { order: { user_id: 1, pickup_address: "Test Address", delivery_address: "Test Delivery", items_description: "Test Items", estimated_value: 10.0 } }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET /orders/:id" do
    it "returns http success" do
      order = Order.create!(user_id: 1, pickup_address: "Test Address", delivery_address: "Test Delivery", items_description: "Test Items", estimated_value: 10.0)
      get "/orders/#{order.id}"
      expect(response).to have_http_status(:success)
    end
  end

end
