class CreatePopulationDays < ActiveRecord::Migration[6.0]
  def change
    create_table :population_days do |t|
      t.references :population_spec, null: false, foreign_key: true
      t.string :name
      t.integer :location

      t.timestamps
    end
  end
end
