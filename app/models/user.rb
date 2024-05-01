class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :buffet
  has_many :orders
  has_one_attached :profile_picture

  validates :full_name, :username, :contact_number, :role, :social_security_number, presence: true
  validates :username, :email, :social_security_number, uniqueness: true
  validates :username, length: { in: 5..20 }
  validates :full_name, length: { minimum: 3 }
  validates :contact_number, length: { in: 14..15 }
  validates :social_security_number, length: { is: 11 }
  validate :is_social_security_number_valid?

  enum role: { customer: 0, owner: 10 }

  private

  def is_social_security_number_valid?
    if !CPF.valid?(social_security_number, strict: true)
      errors.add(:social_security_number, "não é válido.")
    end
  end
end
