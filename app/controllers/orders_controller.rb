class OrdersController < ApplicationController
  before_action :authenticate_user!, except: []

  # Checkout form
  def new
    @cart_items = cart_items_with_products
    redirect_to cart_index_path, alert: "Your cart is empty!" if @cart_items.empty?

    @user = current_user
    @province = @user.province
    @subtotal = @cart_items.sum { |i| i[:subtotal] }
    @tax = @province ? calculate_tax(@subtotal, @province) : 0
    @total = @subtotal + @tax
  end

  # Place the order
  def create
    @cart_items = cart_items_with_products

    # Calculate subtotal and tax again (or use values from params)
    subtotal = @cart_items.sum { |i| i[:subtotal] }
    province = current_user.province
    tax = province ? calculate_tax(subtotal, province) : 0
    total = subtotal + tax

    # Charge via Stripe (if implemented)
    begin
      charge = Stripe::Charge.create(
        amount: (total * 100).to_i,
        currency: 'cad',
        source: params[:stripe_token],
        description: "Prairie Roasters Order - #{current_user.email}"
      )
      stripe_payment_id = charge.id
      stripe_status = 'paid'
    rescue Stripe::CardError => e
      flash[:alert] = e.message
      return redirect_to new_order_path
    end

    @order = Order.new(
      customer: current_user,
      order_date: Time.current,
      status: stripe_status,
      total: total,
      subtotal: subtotal,        # <-- new
      tax_amount: tax,           # <-- new
      stripe_payment_id: stripe_payment_id
    )

    if @order.save
      @cart_items.each do |item|
        @order.order_items.create!(
          product: item[:product],
          quantity: item[:quantity],
          price_at_purchase: item[:product].current_price
        )
      end
      session[:cart] = {}
      flash[:notice] = "Order placed successfully! Order ##{@order.id}"
      redirect_to order_path(@order)
    else
      render :new, alert: "There was a problem placing your order."
    end
  end

  # Feature 3.2.1 - View past orders
  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  private

  def cart_items_with_products
    return [] unless session[:cart]
    session[:cart].map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product
      { product: product, quantity: quantity, subtotal: product.current_price * quantity }
    end.compact
  end

  def calculate_tax(subtotal, province)
    if province.hst > 0
      subtotal * province.hst
    else
      subtotal * (province.gst + province.pst)
    end
  end
end