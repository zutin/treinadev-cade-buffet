class Buffet < ApplicationRecord
  belongs_to :user
  has_many :events
  has_many :orders
  has_one_attached :buffet_logo

  validates :trading_name, :company_name, :registration_number, :contact_number, :email, :address, :district, :state, :city, :zipcode, :description, :payment_methods, presence: true
  validates :registration_number, uniqueness: true
  validates :trading_name, :company_name, length: { in: 3..30 }
  validates :contact_number, length: { in: 10..15 }

  validate :is_registration_number_valid?

  private

  def is_registration_number_valid?
    if !CNPJ.valid?(registration_number, strict: true)
      errors.add(:registration_number, "não é válido.")
    end
  end
end
