json.(population_day, 
      :id, 
	  :name,
	  :location,
	  )

json.population_hours population_day.population_hours, partial: 'population_hours/population_hour', as: :population_hour
