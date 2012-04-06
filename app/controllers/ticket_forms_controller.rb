class TicketFormsController < ApplicationController  
  
  def remove_field
    field_id = params[:id]    
    field = FormField.find_by_id field_id
    if field
      form = field.ticket_form
      field.destroy
      form.write_form
      flash[:notice] = "Field Removed"
      redirect_to form
    else
      flash[:error] = "Error: That field does not exist."
      redirect_to ticket_forms_path
    end
  end
  
  #def new    
   # s_name = params[:selected_name]
    #name = params[:name]
    #if !s_name.blank? and !name.blank?
     # flash[:error] = "Error: Please select an name OR enter a name not both."
      #redirect_to ticket_forms_path
    #elsif !name.blank?
     # session[:form_name] = name  
     # @name = name    
    #elsif !s_name.blank?
    #  session[:form_name] = s_name
    #  @name = s_name
    #elsif session[:form_name]
    #  @name = session[:form_name]
    #else
    #  flash[:error] = "Error: Please select or enter name."
    #  redirect_to ticket_forms_path
    #end    
  #end
  
  def create
    @ticket_form = TicketForm.create!(params[:ticket_form])
    @ticket_form.write_form
    redirect_to @ticket_form
  end
  
  def new_field
    @ticket_form = TicketForm.find_by_id params[:id]
    @description = session[:field_description]
    if !@ticket_form
      flash[:error] = "Error: That form does not exit."
      redirect_to ticket_forms_path 
    end
  end
  
  def destroy
    @tf = TicketForm.find_by_id(params[:id])
    @tf.delete_file
    @tf.destroy
    flash[:notice] = "Form was deleted"
    redirect_to ticket_forms_path    
  end
  
  def index
    @ticket_form = TicketForm.new
    @ticket_forms = TicketForm.all
  end
  
  def show
    @ticket_form = TicketForm.find_by_id params[:id]    
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
        
    options_list = parse_options(params[:options])
    type = params[:field_type]
    if type == "text"
      add_text_field(ticket_form, description, options_list)
    elsif type == "radio"
      add_radio_field(ticket_form, description, options_list)
    end
  end
  
  private
  
    def parse_options(options)      
      options_list = []    
      options.each do |o|
        if !o[1].blank?
          options_list << o[1]
        end
      end  
      options_list    
    end
  
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
        ticket_form.form_fields.create! :description => description,
                                       :field_type => "radio", :options => options
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
