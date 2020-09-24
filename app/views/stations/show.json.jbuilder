json.partial! 'stations/station', station: @station

json.partial! 'population_specs/population_spec', population_spec: @station.population_spec if @station.population_spec