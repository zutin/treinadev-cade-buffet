class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_picture
  has_one :buffet
  has_many :orders
  has_many :chat_messages

  validates :full_name, :username, :contact_number, :role, :social_security_number, presence: true
  validates :username, :email, :social_security_number, uniqueness: true
  validates :username, length: { in: 5..20 }
  validates :full_name, length: { minimum: 3 }
  validates :contact_number, length: { in: 10..15 }
  validates :social_security_number, length: { is: 11 }
  validate :is_social_security_number_valid?

  enum role: { customer: 0, owner: 10 }

  def user_opens_chat_messages(order)
    unseen_messages = ChatMessage.where(order_id: order).where.not(sender_id: self.id).where(status: 'sent')
    unseen_messages.each do |message|
      message.seen!
    end
  end

  private

  def is_social_security_number_valid?
    if !CPF.valid?(social_security_number, strict: true)
      errors.add(:social_security_number, "não é válido.")
    end
  end
end
