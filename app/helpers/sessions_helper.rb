module SessionsHelper
  
  # These functions are used to keep track of the current user and to do 
  # various forms of validation
  
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
  
  def check_if_admin
    if !current_user.admin?   
      flash[:error] = "Error: You don't have permission to access that"
      redirect_to tickets_path
    end    
  end
  
  def deny_user
    if current_user.user?   
      flash[:error] = "Error: You don't have permission to access that"
      redirect_to tickets_path
    end
  end
  
  # Redirects if current user is not an admin or trying to access other than self
  def check_if_admin_or_self
    if current_user.admin?
      return
    elsif current_user.id.to_s != params[:id]
      flash[:error] = "Error: You don't have permission to access that"
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
        flash[:error] = "Error: You don't have permission to access that"
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
