class RenameStartTimeAndEndTimeInTrips < ActiveRecord::Migration[6.0]
  def change
    rename_column :train_schedules, :start_time, :starts_at
    rename_column :train_schedules, :end_time, :ends_at
  end
end
