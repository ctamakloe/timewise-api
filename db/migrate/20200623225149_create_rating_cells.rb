class CreateRatingCells < ActiveRecord::Migration[6.0]
  def change
    create_table :rating_cells do |t|
      t.references :train_schedule, null: false, foreign_key: true
      t.string :rating
      t.string :stop_name
      t.string :stop_code
      t.datetime :stops_at

      t.timestamps
    end
  end
end
