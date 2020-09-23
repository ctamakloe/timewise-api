class CreatePopulationHours < ActiveRecord::Migration[6.0]
  def change
    create_table :population_hours do |t|
      t.references :population_day, null: false, foreign_key: true
      t.integer :hour
      t.integer :population_percent

      t.timestamps
    end
  end
end
