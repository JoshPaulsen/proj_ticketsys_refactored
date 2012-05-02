module SessionsHelper
  
  # These functions are used to keep track of the current user and to do 
  # various forms of validation
  
  def sign_in (user)    
    cookies.permanent.signed[:token] = [user.id, user.salt]
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
    cookies.delete(:token)
  end
  
  def user_from_session   
    User.authenticate_with_salt(*token)
  end 
  
  def token
    cookies.signed[:token] || [nil, nil]
  end
  
  def check_if_signed_in
    if !signed_in?   
      flash[:error] = "Please Sign In"
      redirect_to signin_path
    end    
  end
  
  def check_if_admin
    if !current_user.admin?   
      flash[:error] = "You Do Not Have Permission To Access That"
      redirect_to tickets_path
    end    
  end
  
  def deny_user
    if current_user.user?   
      flash[:error] = "You Do Not Have Permission To Access That"
      redirect_to tickets_path
    end
  end
  
  # Redirects if current user is not an admin or trying to access other than self
  def check_if_admin_or_self
    if current_user.admin?
      return
    elsif current_user.id.to_s != params[:id]
      flash[:error] = "You Do Not Have Permission To Access That"
      redirect_to user_path params[:id]
      return
    end
  end
  
  # Redirects if current user is not an admin or has access to the resource
  def check_if_admin_or_accessible
    if current_user.admin?
      return
    else      
      ids = get_accessible_user_ids(current_user)      
      if !ids.include?(params[:id])
        flash[:error] = "You Do Not Have Permission To Access That"
        if current_user.user?
          redirect_to tickets_path
        else
          redirect_to tickets_path
        end
      end
    end
  end
  
  # Returns a list of IDs of users that user can view
  def get_accessible_user_ids(user)    
    ids = []
    ids << user.id.to_s
    tickets = user.tickets
    
    tickets.each do |t|      
      t.users.each do |u|        
        if !ids.include? u.id.to_s
          ids << u.id.to_s
        end        
      end
    end
    ids
  end
  
end
