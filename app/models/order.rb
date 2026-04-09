class Order < ApplicationRecord
  belongs_to :customer, class_name: 'User', foreign_key: 'customer_id'
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :order_date, presence: true
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending paid shipped delivered cancelled] }

  def tax_amount
    total * 0.13  
  end

  def self.ransackable_attributes(auth_object = nil)
  ["created_at", "customer_id", "id", "order_date", "status", "total", "updated_at"]
end

def self.ransackable_associations(auth_object = nil)
  ["customer", "order_items", "products"]
end
end