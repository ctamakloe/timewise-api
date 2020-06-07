class Trip < ApplicationRecord
  belongs_to :user
  belongs_to :train_schedule
  has_many :trip_stations, dependent: :destroy
  has_many :stations, through: :trip_stations

  validates :status, presence: true,
            inclusion: {in: %w[upcoming in-progress completed],
                        message: '%{value} is not a valid trip status'}

  after_create :retrieve_schedule

  def origin_station
    trip_stations.origin.try(:station)
  end

  def origin
    #TODO: change to code only
    origin_station.try(:name_with_code)
  end

  def destination_station
    trip_stations.destination.try(:station)
  end

  def destination
    #TODO: change to code only
    destination_station.try(:name_with_code)
  end

  def transits
    stations.merge(TripStation.transits)
  end

  def origin_station=(station)
    return if self.trip_stations.where(function: 'origin').present?
    #TODO: check station is not set as destination

    TripStation.create(function: 'origin', trip: self, station_id: station.id)
  end

  def destination_station=(station)
    return if self.trip_stations.where(function: 'destination').present?
    #TODO: check station is not set as origin

    TripStation.create(function: 'destination', trip: self, station_id: station.id)
  end

  private

  def retrieve_schedule
    schedule = self.train_schedule
    if schedule
      self.departs_at = schedule.starts_at
      self.arrives_at = schedule.ends_at
      self.origin_station = schedule.start_station
      self.destination_station = schedule.end_station
    end
    save
  end
end
