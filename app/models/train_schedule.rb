class TrainSchedule < ApplicationRecord
  def start_station_name
    Station.find_by_code(self.start_station).name
  end

  def start_station_code
    self.start_station
  end

  def end_station_name
    Station.find_by_code(self.end_station).name
  end

  def end_station_code
    self.end_station
  end
end
