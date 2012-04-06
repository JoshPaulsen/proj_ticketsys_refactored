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
    if watcher
      @ticket.remove_watcher(watcher)
      flash[:success] = "Watcher Removed from Ticket"      
    else      
      flash[:error] = "Error: That watcher does not exist."
    end
    redirect_to @ticket
  end
  
  def create
    @ticket = Ticket.new(params[:ticket])
    @ticket.department = params[:department]
    if @ticket.title.blank?
      flash[:error] = "Error: Incomplete Ticket"      
      redirect_to new_ticket_path and return
    end    
    
    @ticket.opened_on = Time.now    
    @ticket.set_creator current_user    
    prov = User.find_by_id params[:provider_id]
    
    if !prov
      @ticket.destroy
      flash[:error] = "Error: No Provider could be located for this ticket."      
      redirect_to mytickets_path and return          
    end
    
      
    @ticket.set_provider prov  
    if @ticket.save
      
      answers = params[:answers]
    
      if answers    
        parse_answers(answers, @ticket)
      end
      
      
      redirect_to ticket_path @ticket
    else
      @ticket.destroy
      flash[:error] = "Error: Ticket could not be created."
      redirect_to new_ticket_path
    end
  end
  
  def parse_answers(answers, ticket)
    
    ans_with_option = Regexp.new(/field_(\d+)_option_(\d+)/)
    ans = Regexp.new(/field_(\d+)/)
    
    answers.each do |key, value|      
      a = key.scan(ans)        
      if !a.empty?
        field_id = a[0][0]
        field = FormField.find_by_id field_id
        ticket.questions.create :question => field.description, :answer => value
      end     
    
      #a = key.scan(ans_with_option)
      #if !a.empty?
        #ticket.question.new parse_with_options(a)
      #else
        
      #end
      
    end
    
  end
  
  
  def parse_with_options(answers)
    field_id = answers[0][0]
    option_index = answers[0][1].to_i    
    field = FormField.find_by_id field_id
    if field
      question = field.description
      answer = field.options[option_index]
      {:question => question, :answer => answer}
    end
  end
  
  def parse_without_options(answers)
    ans = Regexp.new(/field_(\d+)/)
  end
  
  
  
  def new_ticket
    @category_id = params[:ticket][:category]    
    service_area = ServiceArea.find_by_id params[:ticket][:service_area]
    
    if !service_area
      flash[:error] = "Error: That service area seems to be invalid"      
      redirect_to mytickets_path and return          
    end 
    
    service_provider = User.next_provider service_area.name    
    if !service_provider
      flash[:error] = "Error: No Provider could be located for this ticket."      
      redirect_to mytickets_path and return          
    end
    @provider_id = service_provider.id
    @department = service_area.name
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
