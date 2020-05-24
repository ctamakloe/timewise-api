class CreateTripStations < ActiveRecord::Migration[6.0]
  def change
    create_table :trip_stations do |t|
      t.references :trip, null: false, foreign_key: true
      t.references :station, null: false, foreign_key: true
      t.string :function

      t.timestamps
    end
  end
end
