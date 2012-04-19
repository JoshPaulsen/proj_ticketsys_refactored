class UsersController < ApplicationController
  
  before_filter :check_if_signed_in
  before_filter :check_if_admin, :only => [:new, :create, :destroy]
  before_filter :check_if_admin_or_self, :only => [:edit, :update]
  before_filter :check_if_admin_or_accessible, :only => [:index, :show]
  
  def new
    @user = User.new
    @service_areas = ServiceArea.all
  end

  def create    
    @user = User.new(params[:user])
    params[:service_area].each do |sa_id, checked|
      if checked == "1"        
        @user.add_service_area_by_id sa_id      
      end
    end
    @user.active = true
    if @user.save
      flash[:notice] = "New user successfully created"
      redirect_to user_path @user
    else
      @user.destroy
      flash[:error] = "Error: User could not be created!"
      redirect_to new_user_path
    end      
  end

  def update
    @user = User.find_by_id(params[:id])
    @user.update_attributes(params[:user])    
    service_areas = params[:service_area]
    
    if service_areas
      service_areas.each do |sa_id, checked|
        if checked == "1"        
          @user.add_service_area_by_id sa_id
        else        
          @user.remove_service_area_by_id sa_id
        end
      end
    end
    
    if @user.save
      flash[:notice] = "User Profile Updated"  
    else
      flash[:error] = "User Profile could not be updated"      
    end 
    redirect_to @user
  end

  def edit
    @user = User.find_by_id(params[:id])
    @service_areas = ServiceArea.active
  end

  def destroy
    @user = User.find_by_id(params[:id])
    @user.destroy
    flash[:notice] = "User was deleted"
    redirect_to users_path
  end
  
  def deactivate
    user = User.find_by_id(params[:id])
    
    if !user
      flash[:error] = "That user does not exist"
      redirect_to users_path and return
    end
    
    if user.inactive?
      flash[:error] = "That user was already deactivated"
      redirect_to users_path and return
    end
    
    user.active = false
    user.save
    flash[:notice] = "User Deactivated"
    redirect_to users_path
  end
  
  def reactivate
    user = User.find_by_id(params[:id])
    
    if !user
      flash[:error] = "That user does not exist"
      redirect_to users_path and return
    end
    
    if user.active?
      flash[:error] = "That user is currently active"
      redirect_to user and return
    end
    
    user.active = true
    user.save
    flash[:notice] = "User Reactivated"
    redirect_to user
  end

  def index
    @users = User.all
  end

  def show    
    @user = User.find_by_id(params[:id])
    if !@user
      flash[:error] = "That user does not exist"
      redirect_to users_path    
    end    
  end  
  
end
