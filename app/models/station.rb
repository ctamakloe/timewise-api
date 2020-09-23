class Station < ApplicationRecord
  has_many :trip_stations
  has_many :trips, through: :trip_stations
  has_one :population_spec, dependent: :destroy

  def name_with_code
    "#{name} (#{code})"
  end
end
