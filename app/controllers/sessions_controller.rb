class SessionsController < ApplicationController
  
  def new
    if signed_in?
      redirect_to tickets_path
    end
  end

  def create
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
    flash[:notice] = "Successfully signed out"
    redirect_to signin_path
  end
  
end
