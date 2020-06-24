json.(trip, 
      :id, 
      :origin_station_name, 
      :origin_station_code, 
      :destination_station_name, 
      :destination_station_code,
      :departs_at, 
      :arrives_at,
      :trip_type, 
      :purpose,
      :travel_direction,
      :status,
      :rating, 
     )
json.rating_cells trip.rating_cells, partial: 'ratings/rating', as: :rating

