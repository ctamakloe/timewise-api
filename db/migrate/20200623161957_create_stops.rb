class CreateStops < ActiveRecord::Migration[6.0]
  def change
    create_table :stops do |t|
      t.references :train_schedule, null: false, foreign_key: true
      t.string :stop_index
      t.string :stop_type
      t.string :station_code
      t.string :station_name
      t.string :platform
      t.datetime :departs_at
      t.datetime :arrives_at

      t.timestamps
    end
  end
end
