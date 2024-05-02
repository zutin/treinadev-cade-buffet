class Order < ApplicationRecord
  belongs_to :buffet
  belongs_to :event
  belongs_to :user
  
  validates :desired_date, :desired_address, :estimated_invitees, :status, presence: true
  validate :desired_date_cannot_be_in_the_past
  
  enum status: { awaiting_evaluation: 0, accepted_by_owner: 10, confirmed: 20, canceled: 30 }
  
  before_create :generate_order_code

  def status_message
    case self.status
    when 'awaiting_evaluation'
      'Aguardando avaliação do buffet'
    when 'accepted_by_owner'
      'Pedido aceito pelo buffet'
    when 'confirmed'
      'Pedido confirmado'
    when 'canceled'
      'Pedido cancelado'
    else
      'Status desconhecido'
    end
  end

  def has_multiple_orders_for_desired_date?
    same_date_orders = Order.where(buffet_id: self.buffet, event_id: self.event, desired_date: self.desired_date).where.not(status: 'canceled')
    same_date_orders.count > 1
  end

  private

  def generate_order_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def desired_date_cannot_be_in_the_past
    if desired_date.present? && desired_date < Date.today
      errors.add(:desired_date, "não pode ser no passado.")
    end
  end

  # Tarefa - Dono de Buffet aprova pedido - Validando data de expiração da aprovação / confirmação do cliente
  # def confirm_expire_date_cannot_be_in_the_past
  #   if confirm_expire_date.present? && confirm_expire_date < Date.today
  #     errors.add(:confirm_expire_date, "não pode ser no passado.")
  #   end
  # end
end
