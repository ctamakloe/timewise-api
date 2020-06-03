class SchedulesController < ApplicationController

  # GET /schedules
  # :start_station => code 
  # :end_station => code 
  # :date YYYY-MM-DD
  # :time HH:MM
  def index
    #    start_time = DateTime.parse("#{params[:date]} #{params[:time]}")
    #    @schedules = TrainSchedule.where(
    #                    start_station: params[:station_station], 
    #                    end_station: params[:end_station], 
    #                    start_time: start_datetime.all_day
    #                  )

    # create a bunch of travel times and return them 
    start_station = Station.find_by_code(params[:start_station])
    end_station = Station.find_by_code(params[:end_station])
    start_time = DateTime.parse("#{params[:date]} #{params[:time]}")

    # create transchedules for the date that gets passed in if nothing is created for that day 

    # if not train schedules on requested day
    date_string = start_time.to_s.split('T').first
    @schedules = TrainSchedule.where(start_time: start_time.all_day).order(start_time: 'asc')
    return @schedules if @schedules.present?

    # create some schedules 
    # before time
    (1..6).each do |diff| 
      st = DateTime.parse("#{start_time.to_s.split('T').first} #{(start_time.hour - diff - diff).abs}:#{rand(1..59)}")
      et = DateTime.parse("#{date_string} #{start_time.hour - diff}:#{rand(1..59)}")
      schedule = TrainSchedule.create(
        start_station: start_station.name, 
        end_station: end_station.name, 
        start_time: st,
        end_time: et,
      )
    end
    # after time
    (1..4).each do |diff| 
      st = DateTime.parse("#{date_string} #{start_time.hour + diff}:#{rand(1..59)}")
      et = DateTime.parse("#{start_time.to_s.split('T').first} #{(start_time.hour + diff + diff).abs}:#{rand(1..59)}")
      schedule = TrainSchedule.create(
        start_station: start_station.name, 
        end_station: end_station.name, 
        start_time: st,
        end_time: et,
      )
    end
    @schedules = TrainSchedule.where(start_time: start_time.all_day).order(start_time: 'asc')
  end
end
