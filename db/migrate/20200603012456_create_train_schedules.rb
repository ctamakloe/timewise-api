class CreateTrainSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :train_schedules do |t|
      t.string :start_station
      t.string :end_station
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
