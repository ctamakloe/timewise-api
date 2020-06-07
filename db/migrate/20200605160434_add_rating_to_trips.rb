class AddRatingToTrips < ActiveRecord::Migration[6.0]
  def change
    add_column :trips, :rating, :string, default: '0'
  end
end
