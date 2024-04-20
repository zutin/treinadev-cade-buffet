class Buffet < ApplicationRecord
  belongs_to :user
  has_many :events
  validates :trading_name, :company_name, :registration_number, :contact_number, :email, :address, :district, :state, :city, :zipcode, :description, :payment_methods, presence: true
  validates :registration_number, uniqueness: true
end
