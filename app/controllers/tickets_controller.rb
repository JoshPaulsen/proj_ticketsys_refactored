class TicketsController < ApplicationController
  
  before_filter :check_if_signed_in
  before_filter :check_if_admin, :only => :destroy
  before_filter :deny_user, :only => [:update, :edit]
  before_filter :check_ticket_access_rights, :except => [:new, :create, :index, :mytickets ]  
  
  def new    
  end 
  
  def addwatcher
    @ticket = Ticket.find_by_id(params[:id])
    watcher = User.find_by_email(params[:user][:email])
    if !watcher.nil?
      
      if @ticket.add_watcher(watcher)
        flash[:success] = "Watcher Added to Ticket"
        redirect_to @ticket
        return
      else
        flash[:error] = "Error: Couldn't add watcher."         
        redirect_to @ticket
        return
      end  
      
    else
      flash[:error] = "Error: No user with that email exists."       
      redirect_to @ticket
      return
    end    
  end
  
  def removewatcher
    @ticket = Ticket.find_by_id(params[:id])
    watcher = User.find_by_id(params[:user][:user_id])    
    if watcher.nil?
      flash[:error] = "Error: That watcher does not exist."       
      redirect_to @ticket
      return
    else
      @ticket.remove_watcher(watcher)
      flash[:success] = "Watcher Removed from Ticket"
      redirect_to @ticket
      return
    end
  end
  
  def create     
    @ticket = Ticket.new(params[:ticket])
    @ticket.opened_on = Time.now    
    @ticket.set_creator current_user    
    prov = User.next_provider(params[:ticket][:department])
    
    if prov.nil? or !@ticket.set_provider prov
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
    
    @ticket = Ticket.find_by_id(params[:id])   
    @ticket.description = params[:ticket][:title]
    @ticket.description = params[:ticket][:description]
    @ticket.department = params[:ticket][:department] 
    
    provider_id = params[:ticket][:provider_id]
    if !provider_id.nil? and provider_id != @ticket.provider_id
      @ticket.set_provider(User.find_by_id(provider_id))
    end
    #old_provider = @ticket.provider
    #@ticket.update_attributes(params[:ticket])    
    if @ticket.save
      #@ticket.set_provider(@ticket.provider)
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
