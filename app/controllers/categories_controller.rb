class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  def show
    # Get all products in this category with pagination
    @products = @category.products
                         .includes(:category, :product_prices)
                         .page(params[:page])
                         .per(12)
    
    # Get all categories for the sidebar/navigation
    @categories = Category.all
    
    # For the page title and breadcrumbs
    @page_title = "#{@category.name} - Prairie Roasters"
  end

  private

  def set_category
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Category not found"
    redirect_to root_path
  end
end