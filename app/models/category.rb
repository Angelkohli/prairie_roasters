class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  def self.ransackable_attributes(auth_object = nil)
  ["created_at", "description", "id", "name", "updated_at"]
end

def self.ransackable_associations(auth_object = nil)
  ["products"]
end
end