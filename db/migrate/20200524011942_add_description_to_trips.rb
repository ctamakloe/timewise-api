class AddDescriptionToTrips < ActiveRecord::Migration[6.0]
  def change
    add_column :trips, :description, :string
  end
end
