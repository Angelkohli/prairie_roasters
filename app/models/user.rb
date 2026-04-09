# app/models/user.rb
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province, optional: true
  has_many :orders, foreign_key: :customer_id

  validates :name, presence: true
  validates :address, presence: true, on: :update

  def self.ransackable_attributes(auth_object = nil)
    %w[id name email address city postal_code province_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[orders province]
  end
end