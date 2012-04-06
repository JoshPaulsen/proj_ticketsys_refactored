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
  
  def new_field
    @ticket_form = TicketForm.find_by_id params[:id]
    @description = session[:field_description]
    if @ticket_form
      
    else
      
    end
    
  end
  
  def create_field
    
    ticket_form = TicketForm.find_by_id params[:id]
    description = params[:description]
    if !ticket_form
      flash[:error] = "Error: That Ticket Form does not exist"      
      redirect_to new_form_field_path and return
    elsif description.blank?
      flash[:error] = "Error: All forms fields need a description"      
      redirect_to new_form_field_path and return        
    end
    
    
    type = params[:field_type]
    options_list = []
    
    params[:options].each do |o|
      if !o[1].blank?
        options_list << o[1]
      end
    end
    
    puts "this is the option list: " 
    puts options_list.to_s
    puts
    
    if type == "text"
      add_text_field(ticket_form, description, options_list)
    elsif type == "radio"
      add_radio_field(ticket_form, description, options_list)
    elsif type == "select"
      
    end
  end
  
  private
  
    def add_text_field(ticket_form, description, options)
      if options.empty?
        session[:field_description] = nil  
        ticket_form.form_fields.create! :description => description, :field_type => "text"
        ticket_form.write_form
        flash[:notice] = "New Field Added"
        redirect_to ticket_form
      else
        flash[:error] = "Error: A text field does not need options"    
        session[:field_description] = description  
        redirect_to new_form_field_path
      end      
    end
    
    def add_radio_field(ticket_form, description, options)
      if options.length < 2
        flash[:error] = "Error: A radio field needs at least two options."    
        session[:field_description] = description  
        redirect_to new_form_field_path
      else
        session[:field_description] = nil  
        ticket_form.form_fields.create! :description => description, :field_type => "text", :options => options
        if ticket_form.write_form
          flash[:notice] = "New Field Added"        
          redirect_to ticket_form
        else
          flash[:error] = "Error: Unable to write form to file."    
          session[:field_description] = description  
          redirect_to new_form_field_path      
        end
      end
    end
end
