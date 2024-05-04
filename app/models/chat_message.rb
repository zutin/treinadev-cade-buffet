class ChatMessage < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :order

  validates :text, :status, presence: true
  validates :text, length: { minimum: 1 }
  validates :text, length: { maximum: 200 }

  enum status: { sent: 0, seen: 10 }

  def has_seen_status
    case self.status
    when 'sent'
      'Enviado'
    when 'seen'
      'Visto'
    else
      'Status desconhecido'
    end
  end
end
