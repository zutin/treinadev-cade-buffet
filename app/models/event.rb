class Event < ApplicationRecord
  belongs_to :buffet
  has_one :event_price
  has_one_attached :event_logo
  validates :name, :description, :minimum_participants, :maximum_participants, :default_duration, :menu, presence: true
  validates :alcoholic_drinks, :decorations, :valet_service, :can_change_location, inclusion: [true, false]
end