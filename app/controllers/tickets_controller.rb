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
  
  def add_user
    @ticket = Ticket.find_by_id(params[:id])
    user = User.find_by_id(params[:user][:user_id])
    if user
      if @ticket.users.include?(user)
        flash[:error] = "Error: That person is already attached to this ticket"
        redirect_to @ticket
      elsif @ticket.add_additional_user(user)
        flash[:success] = "Additional user Added to Ticket"
        redirect_to @ticket
      else # Do we need this?  I don't see a way adding a watcher would fail
        flash[:error] = "Error: Couldn't add user."         
        redirect_to @ticket
      end  
      
    else
      flash[:error] = "Error: Please select a user."       
      redirect_to @ticket
    end    
  end
  
  def add_provider
    @ticket = Ticket.find_by_id(params[:id])
    provider = User.find_by_id(params[:user][:user_id])
    if provider
      if @ticket.users.include?(provider)
        flash[:error] = "Error: That person is already attached to this ticket"
        redirect_to @ticket
      elsif @ticket.add_additional_provider(provider)
        flash[:success] = "Additional user Added to Ticket"
        redirect_to @ticket
      else # Do we need this?  I don't see a way adding a watcher would fail
        flash[:error] = "Error: Couldn't add user."         
        redirect_to @ticket
      end  
      
    else
      flash[:error] = "Error: Please select a user."       
      redirect_to @ticket
    end    
  end
  
  
  def remove_user
    @ticket = Ticket.find_by_id(params[:id])
    user = User.find_by_id(params[:user][:user_id])    
    if user
      @ticket.remove_user(user)
      flash[:success] = "#{user.name} was removed from the ticket"      
    else      
      flash[:error] = "Error: Plese select a user first."
    end
    redirect_to @ticket
  end

  # This was added and not tested yet
  def new_ticket
    sa_form = ServiceAreaForm.find_by_id[:ticket][:form_id]
    service_area = ServiceArea.find_by_id params[:ticket][:service_area_id]
    location = Location.find_by_id params[:ticket][:location_id]
    if !service_area
      flash[:error] = "Error: Please choose a Service Area"
      redirect_to new_ticket_path and return
    end

    if @form_id.blank? or @form_id.nil?
      flash[:error] = "Error: Please choose a Category"
      redirect_to new_ticket_path and return
    end
    
    service_provider = User.next_provider
    if !service_provider
      flash[:error] = "Error: No Provider could be located for this ticket."
      redirect_to mytickets_path and return
    end
    @provider_id = service_provider.id
    @service_area_name = service_area.name
  end

  def create     
    @ticket = Ticket.new(params[:ticket])
    if @ticket.title.blank?
      flash[:error] = "Error: Incomplete Ticket"
      redirect_to new_ticket_path and return
    end

    @ticket.opened_on = Time.now
    
    if !@ticket.set_creator current_user    
      @ticket.destroy
      flash[:error] = "Error: Could not set creator."      
      redirect_to mytickets_path and return          
    end
     
   
    prov = User.next_provider()
    
    if !prov
      @ticket.destroy
      flash[:error] = "Error: No Provider could be located for this ticket."      
      redirect_to mytickets_path and return          
    end 
      
    @ticket.set_provider prov  
    if @ticket.save
      @ticket.add_answers(params[:answers])
      redirect_to ticket_path @ticket
    else
      @ticket.destroy
      flash[:error] = "Error: Ticket could not be created."
      redirect_to new_ticket_path
    end
  end

  def update
    
    @ticket = Ticket.find_by_id(params[:id])
    
    if params[:ticket][:title].blank?
      flash[:error] = "Error: The title cannot be blank" 
      redirect_to edit_ticket_path @ticket and return
    end
    
    @ticket.title = params[:ticket][:title]
    @ticket.description = params[:ticket][:description]
    @ticket.service_area_id = params[:ticket][:service_area_id] 
    
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

  # service provider code probably returns duplicate tickets now
  def index
    if current_user.admin?
      @tickets = Ticket.all
    elsif current_user.service_provider?
      
      @tickets = current_user.tickets
      current_user.service_areas.each do |sa|
        @tickets << sa.tickets
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
