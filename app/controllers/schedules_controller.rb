class SchedulesController < ApplicationController

  # :start_station => code
  # :end_station => code
  # :date YYYY-MM-DD
  # :time HH:MM
  def index

    # TODO: handle exceptions
    # start/end/date not supplied
    # date wrong format to parse

    start_code = params[:start_station]
    end_code = params[:end_station]
    date = Date.parse(params[:date])

    # check if schedules exist for given start/end/date
    @schedules = TrainSchedule.where(
        start_station_code: start_code,
        end_station_code: end_code,
        starts_at: date.all_day
    )

    return if @schedules.present?

    # create new schedules for start/end/date
    @schedules = []
    require 'http'
    endpoint =
        "http://transportapi.com/v3/uk/train/station/#{end_code}/2020-06-15/12:00/timetable.json"\
        "?app_id=#{ENV['TRANSPORT_API_APP_ID']}"\
        "&app_key=#{ENV['TRANSPORT_API_APP_KEY']}"\
        "&type=arrival"\
        "&origin=#{start_code}"\
        "&destination=#{end_code}"\
        "&from_offset=-PT12:00:00"\
        "&to_offset=PT12:00:00"\
        "&station_detail=origin,destination"

    response = HTTP.get(endpoint)
    json = JSON(response.body)
    json['arrivals']['all'].each do |data|
      schedule = TrainSchedule.new(
          start_station_code: data['station_detail']['origin']['station_code'],
          end_station_code: data['station_detail']['destination']['station_code'],

          starts_at: DateTime.parse("#{date} #{data['station_detail']['origin']['aimed_departure_time']}"),
          ends_at: DateTime.parse("#{date} #{data['station_detail']['destination']['aimed_arrival_time']}"),

          operator: data['operator'],
          operator_name: data['operator_name'],
          train_uid: data['train_uid'],
          service: data['service'],
          service_timetable: data['service_timetable']['id'],
      )
      @schedules << schedule if schedule.save
    end
  end
end

# {"mode"=>"train",
#  "service"=>"22154000",
#  "train_uid"=>"W88002",
#  "platform"=>"4",
#  "operator"=>"EM",
#  "operator_name"=>"East Midlands Trains",
#  "aimed_departure_time"=>nil,
#  "aimed_arrival_time"=>"07:36",
#  "aimed_pass_time"=>nil,
#  "origin_name"=>"Nottingham",
#  "destination_name"=>"London St Pancras",
#  "source"=>"ATOC",
#  "category"=>"XX",
#  "service_timetable"=>{"id"=>"http://transportapi.com/v3/uk/train/service/train_uid:W88002/2020-06-15/timetable.json?app_id=d7c2a0d3&app_key=196d2a25e8b5b2609d032658f8ae842b"},
#  "station_detail"=>{
#      "origin"=>{"station_name"=>"Nottingham", "platform"=>"6", "station_code"=>"NOT", "tiploc_code"=>"NTNG", "aimed_arrival_time"=>nil, "aimed_departure_time"=>"05:32", "aimed_pass_time"=>nil},
#      "destination"=>{"station_name"=>"London St Pancras", "platform"=>"4", "station_code"=>"STP", "tiploc_code"=>"STPX", "aimed_arrival_time"=>"07:36", "aimed_departure_time"=>nil, "aimed_pass_time"=>nil}}}


# json['arrivals']['all']

# TrainSchedule(start_station_code, end_station_code, starts_at, ends_at)
# operator, operator_name, train_uid, service, service_timetable,
#
# origin[station_code]
# origin[aimed_departure_time]
# destination[station_code]
# destination[aimed_arrival_time]

#

# TrainSchedule(start_station_code, end_station_code, starts_at, ends_at)
# GET /schedules
# :start_station => code
# :end_station => code
# :date YYYY-MM-DD
# :time HH:MM
# 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyMSwiZXhwIjoxNTkyMjY2MjE3fQ.XJD94ldBRvKoyXNlc0hWwujxHHVimWtnl4sFmfkUPis'

=begin
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
    @schedules = TrainSchedule.where(starts_at: start_time.all_day).order(starts_at: 'asc')
    return @schedules if @schedules.present?

    # create some schedules
    # before time
    (1..6).each do |diff|
      st = DateTime.parse("#{start_time.to_s.split('T').first} #{(start_time.hour - diff - diff).abs}:#{rand(1..59)}")
      et = DateTime.parse("#{date_string} #{start_time.hour - diff}:#{rand(1..59)}")
      schedule = TrainSchedule.create(
        start_station_code: start_station.code,
        end_station_code: end_station.code,
        starts_at: st,
        ends_at: et,
      )
    end
    # after time
    (1..6).each do |diff|
      st = DateTime.parse("#{date_string} #{start_time.hour + diff}:#{rand(1..59)}")
      et = DateTime.parse("#{start_time.to_s.split('T').first} #{(start_time.hour + diff + diff).abs}:#{rand(1..59)}")
      schedule = TrainSchedule.create(
        start_station_code: start_station.code,
        end_station_code: end_station.code,
        starts_at: st,
        ends_at: et,
      )
    end
    @schedules = TrainSchedule.where(starts_at: start_time.all_day).order(starts_at: 'asc')
  end
=end
