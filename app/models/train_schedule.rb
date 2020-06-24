class TrainSchedule < ApplicationRecord
  has_many :trips
  has_many :stops, dependent: :destroy
  has_many :rating_cells, dependent: :destroy

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

  def stop_times
    return if self.stops.empty?

    times = []
    self.stops.each_with_index { |stop, index| index == 0 ? times << stop.departure_time : times << stop.arrival_time }
    times
  end

  def create_stops
    return if self.stops.present?

    require 'http'

    endpoint = service_timetable
    response = HTTP.get(endpoint)
    json = JSON(response.body)

    json['stops'].each_with_index do |stop_data, index|

      stop = Stop.new(
          train_schedule: self,
          stop_index: index,
          stop_type: stop_data['stop_type'],
          station_code: stop_data['station_code'],
          station_name: stop_data['station_name'],
          platform: stop_data['platform'],
      )

      if stop_data['aimed_departure_date'] && stop_data['aimed_departure_time']
        stop.departs_at = DateTime.parse("#{stop_data['aimed_departure_date']} #{stop_data['aimed_departure_time']}")
      end

      if stop_data['aimed_arrival_date'] && stop_data['aimed_arrival_time']
        stop.arrives_at = DateTime.parse("#{stop_data['aimed_arrival_date']} #{stop_data['aimed_arrival_time']}")
      end

      stop.save
    end

  end

  def generate_rating_cells
    return if self.stops.empty?

    return if self.rating_cells.present?

    # create stop rating cells
    self.stops.each do |stop|
      time = stop.stop_type == 'LO' ? stop.departs_at : stop.arrives_at

      cell = self.rating_cells.new(
          stops_at: time,
          stop_name: stop.station_name,
          stop_code: stop.station_code,
          rating: rand(6),
      )
      cell.save
    end

    # create interval rating cells
    interval_count = self.trip_duration.round(-1) / 10
    start_time = self.stops.find_by_stop_type('LO').departs_at

    (0...interval_count).each do |count|

      cell = self.rating_cells.new(
          stops_at: start_time + (count * 10).minutes,
          rating: rand(6),
      )
      cell.save
    end

    true
  end

  def get_rating_cells
    create_stops if self.stops.empty?

    generate_rating_cells if self.rating_cells.empty?

    rating_cells.order(:stops_at)
  end

  def trip_duration
    return if self.stops.empty?

    times = self.stop_times
    (Time.parse(times.first) - Time.parse(times.last)).abs / 3600 * 60
  end
end


=begin

  def rating_cells_old
    return if self.stops.empty?

    interval_times = []

    cell_times = self.stop_times

    start_time = cell_times.first

    interval_count = self.trip_duration.round(-1) / 10

    (0...interval_count).each do |count|
      interval_times << (Time.parse(start_time) + (count * 10).minutes).strftime('%H:%M')
    end

    cell_times << interval_times

    cell_times.flatten.uniq.sort
  end

def leg_durations
  return if self.stops.empty?

  durations = []
  times = self.stop_times
  times.each_with_index do |time, index|
    next if index == 0
    durations << (Time.parse(time) - Time.parse(times[index -1])).abs / 3600 * 60
  end
  durations
end
=end
