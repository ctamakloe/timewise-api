class PopulationSpecsController < ApplicationController
  def create
    # find station, create population spec using population xml 
    station = Station.find_by_code(pop_spec_params[:station_code])
    @pop_spec = station.update_population_data(pop_spec_params[:html_data]) if station 
    
    if @pop_spec
      render 'population_specs/show' 
    else
      render json: { error: 'Pop spec creation failed' }, status: :unprocessable_entity
    end
  end
  
  private 
  
  def pop_spec_params  
    params.require(:population_spec).permit(
      :station_code,
      :html_data, 
    )  
    # html_data 
    # - data is from google maps page source, 
    # - content starting with <div jstcache="xxx" class="section-popular-times-container"
    # => inspect section-popular-times-container, edit as html and copy contents 
    # - needs to be escaped to form valid json  
    # => escape @ https://www.freeformatter.com/json-escape.html 
  end
end
