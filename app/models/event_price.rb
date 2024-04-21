class EventPrice < ApplicationRecord
  belongs_to :event
  validates :base_price, :additional_hour_price, :additional_person_price, :weekend_base_price, :weekend_additional_hour_price, :weekend_additional_person_price, presence: true
end