class CartController < ApplicationController
  def index
    @cart_items = cart_items_with_products
    @total = @cart_items.sum { |item| item[:subtotal] }
  end

  def create
    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_i

    session[:cart] ||= {}
    session[:cart][product_id.to_s] ||= 0
    session[:cart][product_id.to_s] += quantity

    flash[:notice] = "Added to cart!"
    redirect_to cart_index_path
  end

  def update
    product_id = params[:id]
    quantity = params[:quantity].to_i

    session[:cart] ||= {}
    if quantity > 0
      session[:cart][product_id] = quantity
    else
      session[:cart].delete(product_id)
    end

    flash[:notice] = "Cart updated."
    redirect_to cart_index_path
  end

  def destroy
    product_id = params[:id]
    session[:cart]&.delete(product_id)
    flash[:notice] = "Item removed from cart."
    redirect_to cart_index_path
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
end