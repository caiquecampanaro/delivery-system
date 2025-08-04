class OrdersController < ApplicationController
  before_action :set_order, only: [:show]

  # GET /orders
  def index
    @search_term = params[:search_term]
    search_strategy = params[:search_strategy]&.to_sym || :combined
    
    # Usar o OrderSearchService com estratégia configurável
    search_scope = OrderSearchService.search_by_term(@search_term, strategy_type: search_strategy)
    @orders = search_scope.recent.page(params[:page]).per(6)

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
