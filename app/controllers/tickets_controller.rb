class TicketsController < ApplicationController
  
  before_filter :check_if_signed_in
  
  def new    
  end 
  
  def create    
    
    @ticket = Ticket.new(params[:ticket])
    @ticket.opened_on = Time.now
    @ticket.add_creator(current_user)     
    @ticket.add_provider(User.next_provider)  
      
    if @ticket.save
      redirect_to ticket_path @ticket
    else
      flash.now[:error] = "Ticket could not be created"
      render "new"
    end
  end

  def update
    @ticket = Ticket.find(params[:id])
    @ticket.update_attributes(params[:ticket])
    if @ticket.save
      flash[:success] = "Ticket Updated"
      redirect_to @ticket
    else
      flash.now[:error] = "Error: Ticket could not be updated" 
      render "show"
    end 
  end

  def edit
    @ticket = Ticket.find(params[:id])
  end

  def destroy
    @ticket = Ticket.find_by_id(params[:id])
    @ticket.destroy
    flash[:success] = "Ticket was deleted"
    redirect_to tickets_path
  end

  def index    
    @my_tickets = current_user.tickets    
  end

  def show     
    @ticket = Ticket.find_by_id(params[:id])
    @notes = @ticket.notes
    if @ticket.nil?
      flash[:error] = "That ticket does not exist"
      redirect_to tickets_path    
    end      
  end
  
end
