module TicketsHelper
  
  # Checks if the ticket matching :id is a ticket associated with the current user  
  def check_ticket_access_rights
    
    if current_user.admin?
      return
    #elsif current_user.service_provider?
      #ticket = Ticket.find_by_id(params[:id])
    else  
      ticket = Ticket.find_by_id(params[:id])
      if ticket and  current_user.accessible_tickets.include?(ticket)
        return
      end
      
      flash[:error] = "You Do Not Have Permission To Access That"
      redirect_to tickets_path and return
      
      #if ticket      
      #  if current_user.service_areas.include?(ticket.service_area) or 
      #     ticket.users.include?(current_user) 
      #     return
      #  end
      #end
      
      
      
    #else
    #  ticket = Ticket.find_by_id(params[:id])
      
      
     # if !ticket.users.include?(current_user) or !ticket
     #   flash[:error] = "You don't have permission to access that"
     #   redirect_to tickets_path
     # end    
    end  
  end
  
  def parse_to_date(date)
    year = date[:year].to_i
    month = date[:month].to_i
    day = date[:day].to_i
    begin
      Date.new(year, month, day)
    rescue ArgumentError
      nil
    end
  end
  
  def string_to_date(date)    
    begin
      Date.strptime(date, "%m/%d/%Y")
    rescue ArgumentError
      nil
    end
  end
  
end
