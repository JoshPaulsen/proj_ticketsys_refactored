module TicketsHelper
  
  # Checks if the ticket matching :id is a ticket associated with the current user
  def check_ticket_access_rights
    
    if current_user.admin?
      return
    elsif current_user.service_provider?
      tickets = Ticket.where :department => current_user.department
      ids = tickets.map{|t| t.id.to_s}
      tickets << current_user.tickets
      ids += current_user.tickets.map{|t| t.id.to_s}
      if !ids.include?(params[:id])
        flash[:error] = "Error: You don't have permission to access that."
        redirect_to tickets_path
      end
    else
      tickets = current_user.tickets.where(:id => params[:id])
      if tickets.empty?
        flash[:error] = "Error: You don't have permission to access that."
        redirect_to mytickets_path
      end    
    end  
  end
  
end
