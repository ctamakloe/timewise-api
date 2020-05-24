class RemoveDepartsOnFromTrips < ActiveRecord::Migration[6.0]
  def change
    remove_column :trips, :departs_on
  end
end
