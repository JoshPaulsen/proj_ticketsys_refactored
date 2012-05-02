class SessionsController < ApplicationController
  
  def new
    if signed_in?
      redirect_to tickets_path
    end
    if session[:user_signup]
      @first_name = session[:user_signup][0]
      @last_name = session[:user_signup][1]
      @email = session[:user_signup][2]
      session[:user_signup] = nil
    end
  end

  def create
    
    password = params[:password]
    email = params[:email]
    
    user = User.authenticate(email, password)
    
    if user and user.inactive?
      flash[:error] = "Deactivated Account"
      redirect_to signin_path 
    elsif user and !user.verified?
      flash[:error] = "Account Still Pending Verification"
      redirect_to signin_path 
    elsif user
      sign_in(user)        
      redirect_to tickets_path 
    else
      flash[:error] = "Invalid Username/Password"
      redirect_to signin_path 
    end
    
    return
    
    user = User.find_by_name(params[:name])
    
    if user and user.inactive?
      flash[:error] = "Deactivated Account"
      redirect_to signin_path and return
    end
    
    if user and user.password == params[:password]      
        sign_in(user)        
        redirect_to tickets_path
    else
      flash[:error] = "Invalid Username/Password"
      redirect_to signin_path
    end   
  end

  def destroy
    sign_out
    flash[:notice] = "Signed Out"
    redirect_to signin_path
  end
  
end
