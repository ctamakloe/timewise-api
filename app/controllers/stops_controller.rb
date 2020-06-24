class StopsController < ApplicationController
  before_action :set_schedule, only: [:index]

  def index
    @stops = @schedule.stops
    return if @stops.present?

    @stops = []
    require 'http'
    endpoint = @schedule.service_timetable
    response = HTTP.get(endpoint)
    json = JSON(response.body)

    json['stops'].each_with_index do |stop_data, index|

      stop = Stop.new(
          train_schedule: @schedule,
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

      @stops << stop if stop.save
    end

  end

  private

  def set_schedule
    @schedule = TrainSchedule.find(params[:schedule_id])
  end
end

# {
#     "station_code": "MSW",
#     "tiploc_code": "MFLDWSE",
#     "station_name": "Mansfield Woodhouse",
#     "stop_type": "LI", => LI (transit), LT (dest), LO (origin)
#     "platform": "1",
#     "aimed_departure_date": "2020-06-09",
#     "aimed_departure_time": "07:45",
#     "aimed_arrival_date": "2020-06-09",
#     "aimed_arrival_time": "07:44",
#     "aimed_pass_date": null,
#     "aimed_pass_time": null
# }
