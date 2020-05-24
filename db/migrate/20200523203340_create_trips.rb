class CreateTrips < ActiveRecord::Migration[6.0]
  def change
    create_table :trips do |t|
      t.references :user, null: false, foreign_key: true
      t.time :departs_at
      t.time :arrives_at
      t.string :purpose

      t.timestamps
    end
  end
end
