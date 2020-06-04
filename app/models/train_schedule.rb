class TrainSchedule < ApplicationRecord
  has_many :trips

  def start_station
    Station.find_by_code(self.start_station_code)
  end

  def end_station
    Station.find_by_code(self.end_station_code)
  end

  def start_station_name
    start_station.name
  end

  def end_station_name
    end_station.name
  end

  def start_time
    self.starts_at
  end

  def end_time
    self.ends_at
  end
end
