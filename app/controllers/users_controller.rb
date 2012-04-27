class UsersController < ApplicationController
  
  before_filter :check_if_signed_in, :except => [:unverified_user, :user_signup]
  before_filter :check_if_admin, :only => [:new, :create, :destroy]
  before_filter :check_if_admin_or_self, :only => [:edit, :update]
  before_filter :check_if_admin_or_accessible, :only => [:index, :show]
  
  def new
    @user = User.new
    @service_areas = ServiceArea.all
    if session[:new_user]
      @first_name = session[:new_user][0]
      @last_name = session[:new_user][1]
      @email = session[:new_user][2]
      session[:new_user] = nil
    end
  end

  def create
    
    user = params[:user]
    if !user
      flash[:error] = "New User could not be created"
      redirect_to new_user_path and return
    end
    
    @first_name = user[:first_name]
    @last_name = user[:last_name]
    @email = user[:email]
    
    password = user[:password]
    
    if @first_name.blank?
      flash[:error] = "Please enter a first name."
      session[:new_user] = [@first_name, @last_name, @email]
      redirect_to new_user_path and return
    end
    
    if @last_name.blank?
      flash[:error] = "Please enter a last name."
      session[:new_user] = [@first_name, @last_name, @email]
      redirect_to new_user_path and return
    end
    
    if !valid_email? @email
      flash[:error] = "That is not a valid email."
      session[:new_user] = [@first_name, @last_name, nil]
      redirect_to new_user_path and return
      @email = nil
    end
    
    if User.find_by_email @email
      flash[:error] = "A user with that email already exists."
      session[:new_user] = [@first_name, @last_name, nil]
      redirect_to new_user_path and return
    end
    
    if !valid_password? password
      flash[:error] = "Password must be 6 characters long"
      session[:new_user] = [@first_name, @last_name, @email]
      redirect_to new_user_path and return
    end
    
    if password != user[:password_confirmation]     
      flash[:error] = "Passwords don't match"
      session[:new_user] = [@first_name, @last_name, @email]
      redirect_to new_user_path and return
    end
        
    @user = User.new()
    @user.first_name = @first_name
    @user.last_name = @last_name
    @user.email = @email
    @user.set_encrypted_password password
    @user.privilege = params[:user][:privilege]
    @user.active = true
    @user.verified = true
   
    service_areas = params[:service_area]
    if service_areas
      service_areas.each do |sa_id, checked|
        if checked == "1"        
          @user.add_service_area_by_id sa_id      
        end
      end
    end
    
    if @user.save
      flash[:notice] = "New user successfully created"
      redirect_to user_path @user
    else
      @user.destroy
      flash[:error] = "User could not be created!"
      redirect_to new_user_path
    end      
  end
  
  def unverified_user
    @user = User.find_by_id params[:id]
    if !@user
      flash[:error] = "User does not exist"
      redirect_to signin_path and return
    end
    if @user.verified?   
      redirect_to tickets_path and return
    end
  end
  
  def verify
    user = User.find_by_id(params[:id])
    
    if !user
      flash[:error] = "That user does not exist"
      redirect_to users_path and return
    end
    
    if user.verified?
      flash[:error] = "That user has already been verified"
      redirect_to user and return
    end
    
    user.verified = true
    user.save
    flash[:notice] = "User Verified"
    redirect_to user
  end
  
  def user_signup
    user = params[:user]
    if !user
      flash[:error] = "Error: New Account could not be created!"
      redirect_to signin_path and return
    end
    
    @first_name = user[:first_name]
    @last_name = user[:last_name]
    @email = user[:email]
    
    password = user[:password]
    
    if @first_name.blank?
      flash[:error] = "Please enter a first name."
      session[:user_signup] = [@first_name, @last_name, @email]
      redirect_to signin_path and return
    end
    
    if @last_name.blank?
      flash[:error] = "Please enter a last name."
      session[:user_signup] = [@first_name, @last_name, @email]
      redirect_to signin_path and return
    end
    
    if !valid_email? @email
      flash[:error] = "That is not a valid email."
      session[:user_signup] = [@first_name, @last_name, nil]
      redirect_to signin_path and return
      @email = nil
    end
    
    if User.find_by_email @email
      flash[:error] = "A user with that email already exists."
      session[:user_signup] = [@first_name, @last_name, nil]
      redirect_to signin_path and return
    end
    
    if !valid_password? password
      flash[:error] = "Password must be 6 characters long"
      session[:user_signup] = [@first_name, @last_name, @email]
      redirect_to signin_path and return
    end
    
    if password != user[:password_confirmation]     
      flash[:error] = "Passwords don't match"
      session[:user_signup] = [@first_name, @last_name, @email]
      redirect_to signin_path and return
    end
        
    @user = User.new()
    @user.first_name = @first_name
    @user.last_name = @last_name
    @user.email = @email
    @user.set_encrypted_password password
    @user.privilege = "user"
    @user.active = true
    @user.verified = false
    
    if !@user.save
      flash[:error] = "Error: New Account could not be created!"
      redirect_to signin_path and return
    else
      redirect_to unverified_user_path @user
    end
    
  end
  
  def change_password
    @user = User.find_by_id(params[:id])
    
    if !@user
      flash[:error] = "That user does not exist"
      redirect_to users_path and return
    end
    
    password = params[:password]
  
    if !valid_password? password
      flash[:error] = "Password must be 6 characters long"      
      redirect_to edit_user_path @user and return
    end
    
    if password != params[:password_confirmation]     
      flash[:error] = "Passwords don't match"      
      redirect_to edit_user_path @user and return
    end
    
    @user.set_encrypted_password password
    
    if !@user.save
      flash[:error] = "Password could not be changed"
      redirect_to edit_user_path @user and return
    else
      flash[:notice] = "Password Changed"
      redirect_to @user
    end
    
  end

  def update
    @user = User.find_by_id(params[:id])
    @user.update_attributes(params[:user])    
    service_areas = params[:service_area]
    puts "-------"
    puts params[:user]
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
    if !@user
      flash[:error] = "That user does not exist"
      redirect_to users_path and return
    end
    @first_name = @user.first_name
    @last_name = @user.last_name
    @email = @user.email
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
      redirect_to users_path and return
    end  
    @service_areas = @user.service_areas  
  end  
  
end
