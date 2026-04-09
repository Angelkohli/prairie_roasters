class ProductsController < ApplicationController
  def index
    @categories = Category.all
    
    # Feature 2.6 - Keyword search by category
    if params[:query].present? || params[:category_id].present?
      @products = Product.search(params[:query], params[:category_id])
    else
      @products = Product.all
    end

    # Feature 2.4 - Filters
    @products = @products.new_arrivals if params[:filter] == 'new'
    @products = @products.recently_updated if params[:filter] == 'updated'
    @products = @products.on_sale if params[:filter] == 'sale'  # ADD THIS LINE
    
    # Featured sale products for the homepage (if no other filters active)
    @featured_sales = Product.on_sale.limit(6) unless params[:filter].present? || params[:query].present?

    # Feature 2.5 - Pagination (use Kaminari)
    @products = @products.page(params[:page]).per(12)
  end

  def show
    @product = Product.find(params[:id])
    @category = @product.category
  end
end