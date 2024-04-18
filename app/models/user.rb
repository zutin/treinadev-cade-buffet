class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :buffet

  validates :full_name, :username, :contact_number, presence: true
  # Futuramente diferenciar Cliente - Dono
  #validates :role_id, presence: true
  validates :username, :email, uniqueness: true
  validates :username, length: { in: 5..20 }
end
