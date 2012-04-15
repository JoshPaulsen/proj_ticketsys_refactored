module TicketsHelper
  
  # Checks if the ticket matching :id is a ticket associated with the current user  
  def check_ticket_access_rights
    
    if current_user.admin?
      return
    elsif current_user.service_provider?
      ticket = Ticket.find_by_id(params[:id])
      if !ticket.users.include?(current_user) or !current_user.service_areas.include?(ticket.service_area)
        flash[:error] = "Error: You don't have permission to access that"
        redirect_to tickets_path
      end
    else
      ticket = Ticket.find_by_id(params[:id])
      if !ticket.users.include?(current_user)
        flash[:error] = "Error: You don't have permission to access that"
        redirect_to mytickets_path
      end    
    end  
  end
  
end
