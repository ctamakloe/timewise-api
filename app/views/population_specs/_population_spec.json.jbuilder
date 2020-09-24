json.(population_spec, :id, :station_id)

json.population_days population_spec.population_days, partial: 'population_days/population_day', as: :population_day