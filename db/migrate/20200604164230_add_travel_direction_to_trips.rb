class AddTravelDirectionToTrips < ActiveRecord::Migration[6.0]
  def change
    add_column :trips, :travel_direction, :string
  end
end
