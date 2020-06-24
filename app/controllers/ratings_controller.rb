class RatingsController < ApplicationController
  before_action :set_schedule, only: [:index]


  # retrieve stops and use to create rating cells
  def index
    @ratings = @schedule.get_rating_cells
    return if @ratings.present?

    require 'http'
    endpoint = @schedule.service_timetable
    response = HTTP.get(endpoint)
    json = JSON(response.body)

    json['stops'].each_with_index do |stop_data, index|

      stop = @schedule.stops.new(
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

    @ratings = @schedule.get_rating_cells
  end

  private

  def set_schedule
    @trip = current_user.trips.find(params[:trip_id])
    @schedule = @trip.train_schedule if @trip

    # @schedule = TrainSchedule.find(params[:schedule_id])
  end
end
