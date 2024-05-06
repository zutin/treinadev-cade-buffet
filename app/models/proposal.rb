class Proposal < ApplicationRecord
  belongs_to :order

  validates :total_value, :expire_date, :payment_method, presence: true
  validates :total_value, numericality: { greater_than: 0 }

  validate :expire_date_cannot_be_in_the_past

  private

  def expire_date_cannot_be_in_the_past
    if expire_date.present? && expire_date < Date.today
      errors.add(:expire_date, "não pode ser no passado.")
    end
  end
end
