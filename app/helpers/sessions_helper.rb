module SessionsHelper
  
  def sign_in (user)    
    session[:user_id] = user.id
    self.current_user = user    
  end
  
  def current_user=(user)    
    @current_user = user    
  end
  
  def current_user
    @current_user ||= user_from_session
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out    
    self.current_user = nil    
    session[:user_id] = nil
  end
  
  def user_from_session   
    User.find_by_id(session[:user_id])
  end 
  
  def check_if_signed_in
    if !signed_in?   
      flash[:error] = "Please sign in"
      redirect_to signin_path
    end    
  end
  
end
