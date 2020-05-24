class Station < ApplicationRecord
  has_many :trip_stations
  has_many :trips, through: :trip_stations
end
