class ServiceAreasController < ApplicationController
  
  before_filter :check_if_signed_in
  before_filter :check_if_admin
  
  def destroy
    @service_areas = ServiceArea.find_by_id(params[:id])
    @service_areas.destroy
    flash[:notice] = "Service Area was deleted"
    redirect_to service_areas_path
  end  
  
  def index
     @service_areas = ServiceArea.all
  end  
  
  def create
    puts "here -----------------------------------"
    puts params[:service_area]
    @service_area = ServiceArea.new(params[:service_area])
    @service_area.active = true
    if @service_area.save
      flash[:notice] = "New Service Area Added"
      redirect_to service_areas_path
    else
      @service_area.destroy
      flash[:error] = "A Service Area with that name already exists"
      redirect_to service_areas_path
    end    
    
  end
  
  def edit
    @service_area = ServiceArea.find_by_id params[:id]
    puts "here I am"
    if !@service_area
      flash[:error] = "That service area does not exist"
      redirect_to service_areas_path
    end    
  end
  
  
  def update
    service_area = ServiceArea.find_by_id(params[:id])
    service_area.update_attributes(params[:service_area])
    
    if service_area.save
      flash[:notice] = "Service Area Updated"      
    else
      flash[:notice] = "Service Area could not be updated"    
    end
    redirect_to service_areas_path
  end
  
  
  def deactivate
    service_area = ServiceArea.find_by_id(params[:id])    
    if !service_area
      flash[:error] = "That service area does not exist"
      redirect_to service_areas_path and return
    end
    
    if service_area.inactive?
      flash[:error] = "That service area was already deactivated"
      redirect_to service_areas_path and return
    end
    
    service_area.active = false
    service_area.save
    flash[:notice] = "Service Area Deactivated"
    redirect_to service_areas_path
  end
  
  def reactivate
    service_area = ServiceArea.find_by_id(params[:id])
    
    if !service_area
      flash[:error] = "That service area does not exist"
      redirect_to service_areas_path and return
    end
    
    if service_area.active?
      flash[:error] = "That service area is currently active"
      redirect_to service_areas_path and return
    end
    
    service_area.active = true
    service_area.save
    flash[:notice] = "Service Area Reactivated"
    redirect_to service_areas_path
  end
  
end
