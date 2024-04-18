class Buffet < ApplicationRecord
  belongs_to :user
  validates :trading_name, :company_name, :registration_number, :contact_number, :email, :address, :district, :state, :city, :zipcode, :description, presence: true
  validates :registration_number, uniqueness: true
end
