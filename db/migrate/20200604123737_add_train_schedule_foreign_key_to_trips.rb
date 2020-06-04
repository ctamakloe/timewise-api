class AddTrainScheduleForeignKeyToTrips < ActiveRecord::Migration[6.0]
  def change
    add_reference :trips, :train_schedule, foreign_key: true
  end
end
