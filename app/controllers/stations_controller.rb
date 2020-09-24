class StationsController < ApplicationController

  def show
    @station = Station.find(params[:id])
  end  
  
  
  private 
  
  def station_params  
    params.require(:station).permit()  
  end
end
