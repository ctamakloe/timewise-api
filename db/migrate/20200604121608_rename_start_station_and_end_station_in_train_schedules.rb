class RenameStartStationAndEndStationInTrainSchedules < ActiveRecord::Migration[6.0]
  def change
    rename_column :train_schedules, :start_station, :start_station_code
    rename_column :train_schedules, :end_station, :end_station_code
  end
end
