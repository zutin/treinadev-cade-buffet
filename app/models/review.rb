class Review < ApplicationRecord
  belongs_to :order
  belongs_to :reviewer, class_name: 'User'

  has_one_attached :review_photo

  validates :rating, :comment, presence: true
  validates :rating, numericality: { in: 0..5 }
  validates :comment, length: { in: 1..150 }
end
