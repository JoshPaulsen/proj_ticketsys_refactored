class LocationsController < ApplicationController
  
  before_filter :check_if_signed_in
  before_filter :check_if_admin
  
  def destroy
    @locations = Location.find_by_id(params[:id])
    @locations.destroy
    flash[:notice] = "Location Was Deleted"
    redirect_to locations_path
  end  
  
  def index
     @locations = Location.all
  end  
  
  def create
    
    @location = Location.new(params[:location])
    @location.active = true
    if @location.name.blank?
      @location.destroy
      flash[:error] = "A Location Must Have A Name"
      redirect_to locations_path
    elsif @location.save
      flash[:notice] = "New Location Added"
      redirect_to locations_path
    else
      @location.destroy
      flash[:error] = "A Location With That Name Already Exists"
      redirect_to locations_path
    end    
    
  end
  
  def edit
    @location = Location.find_by_id params[:id]
    
    if !@location
      flash[:error] = "That Location Does Not Exist"
      redirect_to locations_path
    end    
  end
  
  
  def update
    location = Location.find_by_id(params[:id])
    location.update_attributes(params[:location])
    
    if location.save
      flash[:notice] = "Location Updated"      
    else
      flash[:notice] = "Location Could Not Be Updated"    
    end
    redirect_to locations_path
  end
  
  
  def deactivate
    location = Location.find_by_id(params[:id])    
    if !location
      flash[:error] = "That Location Does Not Exist"
      redirect_to locations_path and return
    end
    
    if location.inactive?
      flash[:error] = "That Location Was Already Deactivated"
      redirect_to locations_path and return
    end
    
    location.active = false
    location.save
    flash[:notice] = "Location Deactivated"
    redirect_to locations_path
  end
  
  def reactivate
    location = Location.find_by_id(params[:id])
    
    if !location
      flash[:error] = "That Location Does Not Exist"
      redirect_to locations_path and return
    end
    
    if location.active?
      flash[:error] = "That Location Is Currently Active"
      redirect_to locations_path and return
    end
    
    location.active = true
    location.save
    flash[:notice] = "Location Reactivated"
    redirect_to locations_path
  end
  
  
  
end
