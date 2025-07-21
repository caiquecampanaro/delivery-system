class OrdersController < ApplicationController
  before_action :set_order, only: [:show]

  # GET /orders
  def index
    if params[:user_id].present?
      @orders = Order.by_user(params[:user_id]).recent
      @user_id = params[:user_id]
    else
      @orders = Order.all.recent
      @user_id = nil
    end

    respond_to do |format|
      format.html
      format.json { render json: @orders }
    end
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # POST /orders
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to orders_path, notice: 'Pedido criado com sucesso!' }
        format.json { render json: @order, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  # GET /orders/1
  def show
    respond_to do |format|
      format.html
      format.json { render json: @order }
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to orders_path, alert: 'Pedido não encontrado.' }
      format.json { render json: { error: 'Pedido não encontrado' }, status: :not_found }
    end
  end

  def order_params
    params.require(:order).permit(:user_id, :pickup_address, :delivery_address, :items_description, :estimated_value)
  end
end
