module TicketsHelper
  
  def check_ticket_access_rights
    
    if current_user.admin?
      return
    elsif current_user.service_provider?
      tickets = Ticket.where :department => current_user.department, :id => params[:id]
    else
      tickets = current_user.tickets.where :id => params[:id]
    end    
    
    if tickets.empty?
      flash[:error] = "Error: You don't have permission to access that."
      redirect_to mytickets_path
    end    
  end
  
end
