json.(population_spec, :id)
	 
json.station population_spec.station, partial: 'stations/station', as: :station

json.population_days population_spec.population_days, partial: 'population_days/population_day', as: :population_day