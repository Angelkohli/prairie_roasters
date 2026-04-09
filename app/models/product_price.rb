class ProductPrice < ApplicationRecord
  belongs_to :product

  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :effective_date, presence: true
end