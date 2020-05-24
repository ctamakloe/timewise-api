class Station < ApplicationRecord
  has_many :trip_stations
  has_many :trips, through: :trip_stations

  def name_with_code
    "#{name} (#{code})"
  end
end
