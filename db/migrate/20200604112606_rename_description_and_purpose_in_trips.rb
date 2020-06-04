class RenameDescriptionAndPurposeInTrips < ActiveRecord::Migration[6.0]
  def change
    rename_column :trips, :purpose, :trip_type 
    rename_column :trips, :description, :purpose
  end
end
