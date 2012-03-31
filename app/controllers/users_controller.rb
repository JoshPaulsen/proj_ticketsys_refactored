class UsersController < ApplicationController
  
  before_filter :check_if_signed_in
  before_filter :check_if_admin, :only => [:new, :create, :destroy]
  before_filter :check_if_admin_or_self, :only => [:edit, :update]
  before_filter :check_if_admin_or_accessible, :only => [:index, :show]
  
  def new
  end

  def create    
    @user = User.new(params[:user])        
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
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    if @user.save
      flash[:notice] = "User Profile Updated"  
    else
      flash[:error] = "User Profile could not be updated"      
    end 
    redirect_to @user
  end

  def edit
    @user = User.find_by_id(params[:id])
  end

  def destroy
    @user = User.find_by_id(params[:id])
    @user.destroy
    flash[:notice] = "User was deleted"
    redirect_to users_path
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
