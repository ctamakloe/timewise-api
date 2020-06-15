class AddAdditionalFieldsToTrainSchedules < ActiveRecord::Migration[6.0]
  def change
    add_column :train_schedules, :operator, :string
    add_column :train_schedules, :operator_name, :string
    add_column :train_schedules, :train_uid, :string
    add_column :train_schedules, :service, :string
    add_column :train_schedules, :service_timetable, :string
  end
end
