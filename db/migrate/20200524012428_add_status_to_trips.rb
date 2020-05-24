class AddStatusToTrips < ActiveRecord::Migration[6.0]
  def change
    add_column :trips, :status, :string, default: 'upcoming'
  end
end
