class TicketFormsController < ApplicationController
  
  def new    
    s_name = params[:selected_name]
    name = params[:name]
    if !s_name.blank? and !name.blank?
      flash[:error] = "Error: Please select an name OR enter a name not both."
      redirect_to ticket_forms_path
    elsif !name.blank?
      session[:form_name] = name  
      @name = name    
    elsif !s_name.blank?
      session[:form_name] = s_name
      @name = s_name
    elsif session[:form_name]
      @name = session[:form_name]
    else
      flash[:error] = "Error: Please select or enter name."
      redirect_to ticket_forms_path
    end    
  end
  
  def create
    @ticket_form = TicketForm.create!(params[:ticket_form])
    redirect_to @ticket_form
  end
  
  def checkbox
    
    number_of_options = params[:checkbox]
    
    if number_of_options.blank?
      flash[:error] = "Error: Please the number of checkbox options you want."       
      redirect_to new_ticket_form_path and return
    elsif number_of_options.to_i == 0
      flash[:error] = "Error: The number of checkbox options needs to be a positive number."      
      redirect_to new_ticket_form_path and return      
    else
      flash.now[:error] = "Looks good"      
    end
    
    
  end
  
  def index
    @ticket_form = TicketForm.new
    @ticket_forms = TicketForm.all
  end
  
  def show
    @ticket_form = TicketForm.find_by_id params[:id]
    
  end
  
  def newcheckbox
    
  end
  
  def createcheckbox
    @formfield = FormField.new(params[:form_field])
    @options = params[:options]
    
    
  end
  
end
