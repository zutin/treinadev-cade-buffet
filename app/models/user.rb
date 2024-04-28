class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :buffet

  validates :full_name, :username, :contact_number, :role, :social_security_number, presence: true
  validates :username, :email, :social_security_number, uniqueness: true
  validates :username, length: { in: 5..20 }
  validates :social_security_number, social_security_number: { message: 'é inválido.' }

  enum role: { customer: 0, owner: 10 }
end
