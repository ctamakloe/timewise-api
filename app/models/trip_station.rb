class TripStation < ApplicationRecord
  belongs_to :trip
  belongs_to :station

  validates :function, 
            presence: true, inclusion: { in: %w[origin destination transit], 
                            message: '%{value} is not a valid station function' }

  scope :origin, -> { where(function: 'origin').first }
  scope :destination, -> { where(function: 'destination').first }
  scope :transits, -> { where(function: 'transit') }
end
