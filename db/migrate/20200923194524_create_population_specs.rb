class CreatePopulationSpecs < ActiveRecord::Migration[6.0]
  def change
    create_table :population_specs do |t|
      t.references :station, null: false, foreign_key: true

      t.timestamps
    end
  end
end
