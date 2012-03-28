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
  
  def check_if_admin
    if !current_user.admin?   
      flash[:error] = "Error: You don't have permission to access that. check_if_admin"
      redirect_to mytickets_path
    end    
  end
  
  def deny_user
    if current_user.user?   
      flash[:error] = "Error: You don't have permission to access that. deny_user"
      redirect_to mytickets_path
    end
  end
  
  def check_if_admin_or_self
    if current_user.admin?    
      flash.now[:notice] = "Passed admin_or_self."  
      return
    else
      if current_user.id.to_s != params[:id]
        flash[:error] = "Error: You don't have permission to access that admin_or_self.admin_or_self"
        redirect_to user_path params[:id]
        return
      else
        flash.now[:notice] = "Passed admin_or_self."
      end
    end
  end
  
  def check_if_admin_or_accessible
    if current_user.admin?
      return
    else
      puts "THIS IS PARAMS_ID:"
      puts params[:id]
      ids = get_accessible_user_ids(current_user)
      puts "this is all ids"
      puts ids
      if !ids.include?(params[:id])
        flash[:error] = "Error: You don't have permission to access that admin_or_accessible."
        redirect_to tickets_path
      end
    end
  end
  
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
