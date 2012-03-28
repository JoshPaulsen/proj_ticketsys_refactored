class SessionsController < ApplicationController
  def new
    if signed_in?
      redirect_to tickets_path
      return
    end
  end

  def create
    user = User.find_by_name(params[:name])
    @count = User.count
    if user
      if user.password == params[:password] 
        sign_in(user)        
        redirect_to tickets_path
        return
      else
        flash.now[:error] = "Invalid Name/Password"
        render 'new'   
      end
    end   
  end

  def destroy
    sign_out
    redirect_to root_path
    return
  end
end
