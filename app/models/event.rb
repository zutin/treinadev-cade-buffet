class Event < ApplicationRecord
  belongs_to :buffet
  has_one :event_price
  has_one_attached :event_logo
  has_many :order

  validates :name, :description, :minimum_participants, :maximum_participants, :default_duration, :menu, presence: true
  validates :alcoholic_drinks, :decorations, :valet_service, :can_change_location, inclusion: [true, false]
  validates :minimum_participants, :maximum_participants, :default_duration, numericality: { greater_than: 0 }
  validates :name, :description, :menu, length: { minimum: 5 }
  validates :description, :menu, length: { maximum: 160 }
  validates :name, length: { maximum: 80 }

  validate :maximum_participants_cannot_be_less_than_minimum_participants

  private

  def maximum_participants_cannot_be_less_than_minimum_participants
    return if !minimum_participants.present? || !maximum_participants.present?
    if maximum_participants < minimum_participants
      errors.add(:maximum_participants, "não pode ser menor que a quantidade mínima de participantes.")
    end
  end
end