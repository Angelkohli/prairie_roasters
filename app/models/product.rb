class Product < ApplicationRecord
  belongs_to :category
  has_many :product_prices, dependent: :destroy
  has_many :order_items
  has_many :orders, through: :order_items
  has_one_attached :image   # Active Storage

  validates :name, presence: true
  validates :description, presence: true
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :roast_level, inclusion: { in: %w[Light Medium Medium-Dark Dark] }, allow_nil: true
  validates :category, presence: true
  
  validates :on_sale, inclusion: { in: [true, false] }, allow_nil: true
  
  # Sale Feature - 
  validates :sale_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  
  scope :new_arrivals, -> { where('created_at >= ?', 3.days.ago) }
  scope :recently_updated, -> { where('updated_at >= ? AND created_at < ?', 3.days.ago, 3.days.ago) }
  
  scope :on_sale, -> { where(on_sale: true).where.not(sale_price: nil) }
  scope :featured, -> { where(on_sale: true).limit(6) }  # For featured sales on homepage

  def current_price
    if on_sale? && sale_price.present? && sale_price > 0
      sale_price
    else
      product_prices.order(effective_date: :desc).first&.price || 0
    end
  end

  def original_price
    product_prices.order(effective_date: :desc).first&.price || 0
  end

  def on_sale?
    on_sale == true && sale_price.present? && sale_price > 0 && sale_price < original_price
  end

  def discount_percentage
    return 0 unless on_sale? && original_price > 0
    ((original_price - sale_price) / original_price * 100).round
  end

  def self.search(query, category_id = nil)
    results = all
    if query.present?
      # SQLite version - case insensitive search
      results = results.where("name LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%")
    end
    if category_id.present?
      results = results.where(category_id: category_id)
    end
    results
  end

  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "description", "id", "name", "origin", "roast_level", "stock_quantity", "updated_at", "on_sale", "sale_price"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "order_items", "product_prices"]
  end
end