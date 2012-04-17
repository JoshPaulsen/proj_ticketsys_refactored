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
      flash[:error] = "Error: Please select a user first."       
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
        flash[:success] = "Additional provider Added to Ticket"
        redirect_to @ticket
      else # Do we need this?  I don't see a way adding a watcher would fail
        flash[:error] = "Error: Couldn't add user."         
        redirect_to @ticket
      end  
      
    else
      flash[:error] = "Error: Please select a provider first."       
      redirect_to edit_ticket_path @ticket
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


  def new_ticket
    @debug_value = params
    location = Location.find_by_id params[:ticket][:location_id]
    if !location
      flash[:error] = "Error: Please choose a Location"
      redirect_to new_ticket_path and return
    end
    
    service_area = ServiceArea.find_by_id params[:ticket][:service_area_id]
    if !service_area
      flash[:error] = "Error: Please choose a Service Area"
      redirect_to new_ticket_path and return
    end

    sa_form = ServiceAreaForm.find_by_id params[:ticket][:form_id]
    if !sa_form
      flash[:error] = "Error: Please choose a Ticket Type"
      redirect_to new_ticket_path and return
    end

    rule = sa_form.rules.where(:location_id => location.id).first
    if rule
      @provider_id = rule.provider_id
    else
      @provider_id = sa_form.default_provider_id
    end
    
    if !sa_form.file_exist?
      if sa_form.write_form
        @form_id = sa_form.id
      else
        @form_id = nil
      end
    else  
       @form_id = sa_form.id
    end

    @ticket_type = sa_form.title
    @service_area_id = service_area.id
    @service_area_name = service_area.name
    @location_name = location.name
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
    
    provider_id = params[:provider_id]
    if provider_id
      @ticket.set_provider_by_id provider_id
    end
    
    if @ticket.save
      @ticket.add_answers(params[:answers])
      redirect_to @ticket
    else
      @ticket.destroy
      flash[:error] = "Error: Ticket could not be created."
      redirect_to new_ticket_path
    end
  end
  
  def set_primary_provider
    @ticket = Ticket.find_by_id(params[:id])
    provider_id = params[:ticket][:provider_id]
    
    if provider_id.blank?
      flash[:error] = "Error: Provider cannot be blank."
      redirect_to edit_ticket_path @ticket and return
    end
    
    if provider_id == @ticket.creator_id.to_s
      flash[:error] = "Error: The provider and the creator cannot be the same person."
      redirect_to edit_ticket_path @ticket and return
    end
    
    if provider_id != @ticket.provider_id.to_s
      @ticket.set_provider_by_id provider_id
      flash[:notice] = "Provider Updated"
    end
    redirect_to edit_ticket_path @ticket
    
  end

  def update
    
    @ticket = Ticket.find_by_id(params[:id])
    
    if params[:ticket][:title].blank?
      flash[:error] = "Error: The title cannot be blank" 
      redirect_to edit_ticket_path @ticket and return
    end
    
    @ticket.title = params[:ticket][:title]
    @ticket.description = params[:ticket][:description]
    #@ticket.service_area_id = params[:ticket][:service_area_id]
    
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
    if @ticket.service_area
      @service_area_name = @ticket.service_area.name
    end
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
    if !@ticket
      flash[:error] = "That ticket does not exist: " + params[:id]
      redirect_to tickets_path   
    else      
      @notes = @ticket.notes
      if @ticket.service_area
        @service_area_name = @ticket.service_area.name
      end
      
    end      
  end
  
end
