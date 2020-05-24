class AddDepartsOnToTrips < ActiveRecord::Migration[6.0]
  def change
    add_column :trips, :departs_on, :date
  end
end
