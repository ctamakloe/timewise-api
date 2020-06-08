class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :update, :destroy]

  # GET /trips
  def index
    @trips = current_user.trips

    # render json: @trips
  end

  # GET /trips/1
  def show
    # render json: @trip
  end

  # POST /trips
  def create
    @trip = current_user.trips.new(trip_params)

    if @trip.save
      # render json: @trip, status: :created, location: @trip
      render 'trips/show', status: :created
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /trips/1
  def update
    if @trip.update(trip_params)
      # render json: @trip
      render 'trips/show' #, status: :created
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  # DELETE /trips/1
  def destroy
    @trip.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_trip
    @trip = current_user.trips.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def trip_params
    params.require(:trip).permit(
        :origin_station_name,
        :origin_station_code,
        :destination_station_name,
        :destination_station_code,

        # :id,
        :departs_at,
        :arrives_at,

        :trip_type,
        :purpose,
        :status, 
        :travel_direction,
        :train_schedule_id,
        :rating, 
    )
  end
end
