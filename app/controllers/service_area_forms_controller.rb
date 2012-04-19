class ServiceAreaFormsController < ApplicationController
  
  before_filter :check_if_signed_in
  
  def move_up
    form = ServiceAreaForm.find_by_id params[:id]
    field = Field.find_by_id params[:field_id]
    
    if !form
      flash[:error] = "Error: That form does not exist"
      redirect_to service_area_forms_path
    end
    
    if !field
      flash[:error] = "Error: A field that does not exist cannot be moved up"
      redirect_to form
    end
    
    if form.move_up field
      flash[:notice] = "Field moved up"
      redirect_to form
    else
      flash[:error] = "Error: Couldn't move field"
      redirect_to form
    end
    
    
  end
    
  def move_down
    form = ServiceAreaForm.find_by_id params[:id]
    field = Field.find_by_id params[:field_id]
    
    if !form
      flash[:error] = "Error: That form does not exist"
      redirect_to service_area_forms_path
    end
    
    if !field
      flash[:error] = "Error: A field that does not exist cannot be moved up"
      redirect_to form
    end
    
    if form.move_down field
      flash[:notice] = "Field moved down"
      redirect_to form
    else
      flash[:error] = "Error: Couldn't move field"
      redirect_to form
    end
  end  
  
  
  def remove_field
    field = Field.find_by_id params[:id]
    if field
      form = field.form
      field.destroy
      form.update_field_order field.position
      flash[:notice] = "Field Removed"
      redirect_to form
    else
      flash[:error] = "Error: That field does not exist."
      redirect_to service_area_forms_path
    end
  end
  
  def set_providers
    @form = ServiceAreaForm.find_by_id params[:id]
    @form.rules.destroy_all
    locations = params[:location]
    default_provider_id = params[:default_provider][:id]
    locations.each do |location_id, provider_id|
      if !provider_id.blank?
        @form.rules.build(:location_id => location_id, :provider_id => provider_id)
      end
    end
    @form.default_provider_id = default_provider_id
    if !@form.save
      flash[:error] = "Error: Couldn't set providers."
      redirect_to @form and return
    end
    flash[:notice] = "Providers Updated"
    redirect_to @form
  end
  
  def create
    @ticket_form = ServiceAreaForm.create!(params[:service_area_form])
    redirect_to @ticket_form
  end
  
  def new_field
    @ticket_form = ServiceAreaForm.find_by_id params[:id]
    @question = session[:field_question]
    if !@ticket_form
      flash[:error] = "Error: That form does not exist"
      redirect_to service_area_forms_path 
    end
  end
  
  def destroy
    form = ServiceAreaForm.find_by_id(params[:id])
    form.destroy
    flash[:notice] = "Form was deleted"
    redirect_to service_area_forms_path    
  end
  
  def index
    @ticket_form = ServiceAreaForm.new
    @ticket_forms = ServiceAreaForm.all
  end
  
  def show
    @ticket_form = ServiceAreaForm.find_by_id params[:id]
    @locations = Location.all
    @service_area = @ticket_form.service_area
    @default_provider = @ticket_form.default_provider
    @rules = @ticket_form.rules
    
    @form_engine = @ticket_form.get_form_engine
    @tag_helper = get_tag_helper
    
    #@sp_for_location = []
    @sp_id_for_loc = []
    @locations.each do |l|      
      rule = @rules.where(:location_id => l.id).first      
      if rule
        @sp_id_for_loc << rule.provider_id
      else
        @sp_id_for_loc << nil
      end
    end
  end  
  
  def create_field
    
    ticket_form = ServiceAreaForm.find_by_id params[:id]
    question = params[:question]
    if !ticket_form
      flash[:error] = "Error: That Ticket Form does not exist"      
      redirect_to new_form_field_path and return
    elsif question.blank?
      flash[:error] = "Error: All forms fields need a description"      
      redirect_to new_form_field_path and return        
    end
        
    options_list = parse_options(params[:options])
    type = params[:field_type]
    if type == "text"
      add_text_field(ticket_form, question, options_list)
    elsif type == "radio"
      add_radio_field(ticket_form, question, options_list)
    elsif type == "select"
      add_select_field(ticket_form, question, options_list)
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
  
    def add_text_field(ticket_form, question, options)
      if options.empty?
        session[:field_question] = nil  
        ticket_form.fields.create! :question => question, :field_type => "text",
                                   :position => ticket_form.fields.count + 1 
        #attempt_write(ticket_form)
        flash[:notice] = "New Field Added"
        redirect_to ticket_form
      else
        flash[:error] = "Error: A text field does not need options"    
        session[:field_question] = question  
        redirect_to new_form_field_path
      end      
    end
    
    def add_radio_field(ticket_form, question, options)
      if options.length < 2
        flash[:error] = "Error: A radio field needs at least two options."    
        session[:field_question] = question  
        redirect_to new_form_field_path
      else
        session[:field_question] = nil  
        ticket_form.fields.create! :question => question, :position => ticket_form.fields.count + 1, 
                                   :field_type => "radio", :options => options
        flash[:notice] = "New Field Added"        
        redirect_to ticket_form
        #if ticket_form.write_form
        #  flash[:notice] = "New Field Added"        
        #  redirect_to ticket_form
        #else
        #  flash[:error] = "Error: Unable to write form to file."    
        #  session[:field_question] = question  
        #  redirect_to new_form_field_path      
        #end
      end
    end
    
    def add_select_field(ticket_form, question, options)
      if options.length < 2
        flash[:error] = "Error: A select field needs at least two options."    
        session[:field_question] = question  
        redirect_to new_form_field_path
      else
        session[:field_question] = nil  
        ticket_form.fields.create! :question => question, :position => ticket_form.fields.count + 1, 
                                   :field_type => "select", :options => options
        flash[:notice] = "New Field Added"        
        redirect_to ticket_form        
      end
    end
    
end
