class RemoveDepartsAtAndArrivesAtFromTrips < ActiveRecord::Migration[6.0]
  def change
    remove_column :trips, :departs_at
    remove_column :trips, :arrives_at
  end
end
