class AddDepartsAtAndArrivesAtToTrips < ActiveRecord::Migration[6.0]
  def change
    add_column :trips, :departs_at, :datetime
    add_column :trips, :arrives_at, :datetime
  end
end
