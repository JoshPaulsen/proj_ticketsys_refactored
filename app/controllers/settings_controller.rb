class SettingsController < ApplicationController
  def index
  end
  
  def service_areas
    @service_areas = ServiceArea.all
  end
  
  def create_service_area
    
    @service_area = ServiceArea.new(params[:service_area])        
    if @service_area.save
      flash[:notice] = "New Service Area Added"
      redirect_to service_areas_path
    else
      @service_area.destroy
      flash[:error] = "Error: A Service Area with that name already exists"
      redirect_to service_areas_path
    end    
    
  end
  
  def locations
    @locations = Location.all
  end
  
  def create_location
    
    @location = Location.new(params[:location])        
    if @location.save
      flash[:notice] = "New Location Added"
      redirect_to locations_path
    else
      @location.destroy
      flash[:error] = "Error: A Location with that name already exists"
      redirect_to locations_path
    end    
    
  end
end
