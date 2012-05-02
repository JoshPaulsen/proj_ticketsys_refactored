class ServiceAreaFormsController < ApplicationController
  
  before_filter :check_if_signed_in
  before_filter :deny_user
  
  def move_up
    form = ServiceAreaForm.find_by_id params[:id]
    field = Field.find_by_id params[:field_id]
    
    if !form
      flash[:error] = "That Form Does Not Exist"
      redirect_to service_area_forms_path and return
    end
    
    if !field
      flash[:error] = "A Field That Does Not Exist Cannot Be Moved Up"
      redirect_to form and return
    end
    
    if !form.move_up field      
      flash[:error] = "Could Not Move Field"      
    end
    redirect_to form
  end
    
  def move_down
    form = ServiceAreaForm.find_by_id params[:id]
    field = Field.find_by_id params[:field_id]
    
    if !form
      flash[:error] = "That Form Does Not Exist"
      redirect_to service_area_forms_path and return
    end
    
    if !field
      flash[:error] = "A Field That Does Not Exist Cannot Be Moved Down"
      redirect_to form and return
    end
    
    if !form.move_down field
      flash[:error] = "Could Not Move Field"      
    end
    redirect_to form
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
      flash[:error] = "That Field Does Not Exist"
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
      flash[:error] = "Could Not Set Providers"
      redirect_to @form and return
    end
    flash[:notice] = "Providers Updated"
    redirect_to @form
  end
  
  def create
    service_area_id = params[:service_area_form][:service_area_id]
    title = params[:service_area_form][:title]
    
    if service_area_id.blank?
      flash[:error] = "Please Choose A Service Area"
      redirect_to service_area_forms_path and return
    end
    
    if title.blank?
      flash[:error] = "All Forms Need A Type"
      redirect_to service_area_forms_path and return
    end
    
    @ticket_form = ServiceAreaForm.create!(params[:service_area_form])
    redirect_to @ticket_form
  end
  
  def new_field
    @options_list = session[:options_list]
    if !@options_list
      @options_list = []
    end
    @ticket_form = ServiceAreaForm.find_by_id params[:id]
    @question = session[:field_question]
    @type = session[:field_type]
    if !@ticket_form
      flash[:error] = "That Form Does Not Exist"
      redirect_to service_area_forms_path 
    end
  end
  
  def destroy
    form = ServiceAreaForm.find_by_id(params[:id])
    form.destroy
    flash[:notice] = "Form Was Deleted"
    redirect_to service_area_forms_path    
  end
  
  def index
    @ticket_form = ServiceAreaForm.new
    if current_user.admin?
      @ticket_forms = ServiceAreaForm.all
    else
      @ticket_forms = ServiceAreaForm.where("service_area_id IN #{current_user.service_area_ids_to_s}") 
    end
  end
  
  def show
    @form = ServiceAreaForm.find_by_id params[:id]
    @locations = Location.all
    @service_area = @form.service_area
    @default_provider = @form.default_provider
    @rules = @form.rules
    
    @form_engine = @form.get_form_engine
    @form_helper = get_form_helper
    
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
    @options_list = parse_options(params[:options])
    @debug_value = @options_list  
    @type = params[:field_type]
    if !ticket_form
      flash[:error] = "That Ticket Form Does Not Exist"         
      redirect_to new_form_field_path and return
    elsif question.blank?
      session[:options_list] = @options_list   
      session[:field_type] = @type  
      flash[:error] = "All Forms Fields Need A Question"      
      redirect_to new_form_field_path and return        
    end
    
    if @type == "text"
      add_text_field(ticket_form, question, @options_list)
    elsif @type == "radio"
      add_radio_field(ticket_form, question, @options_list)
    elsif @type == "select"
      add_select_field(ticket_form, question, @options_list)
    elsif @type == "check_box"
      add_check_box_field(ticket_form, question, @options_list)
    else
      flash[:error] = "Unknown Field Type"      
      redirect_to new_form_field_path and return        
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
        session[:options_list] = nil   
        session[:field_type] = nil     
        ticket_form.fields.create! :question => question, :field_type => "text",
                                   :position => ticket_form.fields.count + 1
        flash[:notice] = "New Field Added"
        redirect_to ticket_form
      else
        flash[:error] = "A Text Field Does Not Need Options"    
        session[:field_question] = question
        session[:options_list] = @options_list
        session[:field_type] = @type
        redirect_to new_form_field_path
      end      
    end
    
    def add_radio_field(ticket_form, question, options)
      if options.length < 2
        flash[:error] = "A Radio Button Field Needs At Least Two Options."    
        session[:field_question] = question 
        session[:options_list] = @options_list 
        session[:field_type] = @type
        redirect_to new_form_field_path
      else
        session[:field_question] = nil  
        session[:options_list] = nil
        session[:field_type] = nil   
        ticket_form.fields.create! :question => question, :position => ticket_form.fields.count + 1, 
                                   :field_type => "radio", :options => options
        flash[:notice] = "New Field Added"        
        redirect_to ticket_form
      end
    end
    
    def add_select_field(ticket_form, question, options)
      if options.length < 2
        flash[:error] = "A select field needs at least two options."    
        session[:field_question] = question  
        session[:options_list] = @options_list
        session[:field_type] = @type
        redirect_to new_form_field_path
      else
        session[:field_question] = nil  
        session[:options_list] = nil
        session[:field_type] = nil   
        ticket_form.fields.create! :question => question, :position => ticket_form.fields.count + 1, 
                                   :field_type => "select", :options => options
        flash[:notice] = "New Field Added"        
        redirect_to ticket_form        
      end
    end
    
    def add_check_box_field(ticket_form, question, options)
      if options.empty?
        session[:field_question] = nil 
        session[:options_list] = nil 
        session[:field_type] = nil   
        ticket_form.fields.create! :question => question, :field_type => "check box",
                                   :position => ticket_form.fields.count + 1
        flash[:notice] = "New Field Added"
        redirect_to ticket_form
      else
        flash[:error] = "A check box field does not need options"    
        session[:field_question] = question  
        session[:options_list] = @options_list
        session[:field_type] = @type
        redirect_to new_form_field_path
      end      
    end
    
end
