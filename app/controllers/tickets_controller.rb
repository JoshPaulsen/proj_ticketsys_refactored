class TicketsController < ApplicationController
  
  before_filter :check_if_signed_in
  
  def new    
  end 
  
  def create     
    @ticket = Ticket.new(params[:ticket])
    @ticket.opened_on = Time.now    
    @ticket.add_creator current_user    
    prov = User.next_provider(params[:ticket][:department])
    
    if prov.nil? or !@ticket.add_provider prov
      @ticket.destroy
      flash.now[:error] = "Error: No Provider could be located for this ticket."
      @tickets = current_user.tickets
      render "mytickets"
      return    
    end    
      
    if @ticket.save
      redirect_to ticket_path @ticket
    else
      @ticket.destroy
      flash.now[:error] = "Error: Ticket could not be created."
      @tickets = current_user.tickets
      render "mytickets"
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
    if current_user.admin?
      @tickets = Ticket.all
    elsif current_user.service_provider?
      @tickets = Ticket.all
    else
      redirect_to mytickets_path
    end    
  end
  
  def mytickets    
    @tickets = current_user.tickets
  end

  def show  
    @ticket = Ticket.find_by_id(params[:id])    
    if @ticket.nil?
      flash[:error] = "That ticket does not exist: " + params[:id]
      redirect_to tickets_path   
    else
      @notes = @ticket.notes  
    end      
  end
  
end
