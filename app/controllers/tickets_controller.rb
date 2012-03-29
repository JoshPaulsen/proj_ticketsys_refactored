class TicketsController < ApplicationController
  
  before_filter :check_if_signed_in
  before_filter :check_if_admin, :only => :destroy
  before_filter :deny_user, :only => [:update, :edit]
  before_filter :check_ticket_access_rights, :except => [:new, :create, :index, :mytickets ]  
  
  def new    
  end 
  
  def close    
    @ticket = Ticket.find_by_id(params[:id])
    if @ticket.closed?
      flash[:error] = "Error: That ticket is already closed."
      redirect_to @ticket and return      
    end
    @ticket.closed_on = Time.now
    @ticket.save
    flash[:success] = "Ticket successfully closed."
    redirect_to mytickets_path
  end
  
  def open
    @ticket = Ticket.find_by_id(params[:id])
    if @ticket.open?
      flash[:error] = "Error: That ticket is already open."
      redirect_to @ticket and return      
    end
    @ticket.closed_on = ""
    @ticket.save
    flash[:success] = "Ticket successfully reopened."
    redirect_to @ticket
  end
  
  
  # Used to add a person who has access to the ticket but is not the 
  # creator or main service provider  
  def addwatcher
    @ticket = Ticket.find_by_id(params[:id])
    watcher = User.find_by_email(params[:user][:email])
    if watcher
      
      if @ticket.users.include?(watcher)
        flash[:error] = "Error: That person is already watching this ticket"
        redirect_to @ticket
      elsif @ticket.add_watcher(watcher)
        flash[:success] = "Watcher Added to Ticket"
        redirect_to @ticket
      else # Do we need this?  I don't see a way adding a watcher would fail
        flash[:error] = "Error: Couldn't add watcher."         
        redirect_to @ticket
      end  
      
    else
      flash[:error] = "Error: No user with that email exists."       
      redirect_to @ticket
    end    
  end
  
  # Used to remove a watcher
  # Do we need to check if the watcher is nil?  The watchers come from a form
  # That is populated with valid watchers.
  def removewatcher
    @ticket = Ticket.find_by_id(params[:id])
    watcher = User.find_by_id(params[:user][:user_id])    
    if watcher.nil?
      flash[:error] = "Error: That watcher does not exist."       
      redirect_to @ticket
    else
      @ticket.remove_watcher(watcher)
      flash[:success] = "Watcher Removed from Ticket"
      redirect_to @ticket
    end
  end
  
  def create     
    @ticket = Ticket.new(params[:ticket])
    if @ticket.title.blank?
      flash[:error] = "Error: Incomplete Ticket"      
      redirect_to new_ticket_path and return
    end
    @ticket.opened_on = Time.now    
    @ticket.set_creator current_user    
    prov = User.next_provider(params[:ticket][:department])
    
    if prov.nil? or !@ticket.set_provider prov
      @ticket.destroy
      flash[:error] = "Error: No Provider could be located for this ticket."      
      redirect_to mytickets_path and return          
    end 
      
    if @ticket.save
      redirect_to ticket_path @ticket
    else
      @ticket.destroy
      flash[:error] = "Error: Ticket could not be created."
      redirect_to new_ticket_path
    end
  end

  def update
    
    @ticket = Ticket.find_by_id(params[:id])   
    @ticket.description = params[:ticket][:title]
    @ticket.description = params[:ticket][:description]
    @ticket.department = params[:ticket][:department] 
    
    provider_id = params[:ticket][:provider_id]
    if !provider_id.nil? and provider_id != @ticket.provider_id
      @ticket.set_provider(User.find_by_id(provider_id))
    end
    
    if @ticket.save
      flash[:success] = "Ticket Updated"
      redirect_to @ticket
    else
      flash[:error] = "Error: Ticket could not be updated" 
      redirect_to @ticket
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

  # service provider code could be cleaned up
  def index
    if current_user.admin?
      @tickets = Ticket.all
    elsif current_user.service_provider?      
      @tickets = Ticket.where :department => current_user.department      
      current_user.tickets.each do |tic|
        if !@tickets.include?(tic)
          @tickets << tic
        end
      end
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
