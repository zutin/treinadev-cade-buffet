class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :buffet
  has_many :orders

  validates :full_name, :username, :contact_number, :role, :social_security_number, presence: true
  validates :username, :email, :social_security_number, uniqueness: true
  validates :username, length: { in: 5..20 }
  validates :full_name, length: { minimum: 3 }
  validates :contact_number, length: { in: 14..15 }
  validates :social_security_number, length: { is: 11 }
  validates :social_security_number, social_security_number: {}

  enum role: { customer: 0, owner: 10 }
end
