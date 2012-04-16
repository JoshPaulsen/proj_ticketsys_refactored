class ServiceAreaFormsController < ApplicationController
  
  before_filter :check_if_signed_in
  
  def remove_field
    field_id = params[:id]    
    field = Field.find_by_id field_id
    if field
      form = field.form
      field.destroy
      form.write_form
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
    flash[:notice] = "Updated Providers."
    redirect_to @form
  end
  
  def create
    @ticket_form = ServiceAreaForm.create!(params[:service_area_form])
    @ticket_form.write_form
    redirect_to @ticket_form
  end
  
  def new_field
    @ticket_form = ServiceAreaForm.find_by_id params[:id]
    @question = session[:field_question]
    if !@ticket_form
      flash[:error] = "Error: That form does not exit."
      redirect_to service_area_forms_path 
    end
  end
  
  def destroy
    @tf = ServiceAreaForm.find_by_id(params[:id])
    @tf.delete_file
    @tf.destroy
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
    
    @sp_for_location = []
    @sp_id_for_loc = []
    @locations.each do |l|      
      rule = @rules.where(:location_id => l.id).first      
      if rule
        #@sp_for_location << rule.provider.name
        @sp_id_for_loc << rule.provider_id
      else
        #@sp_for_location << nil
        @sp_id_for_loc << nil
      end
    end
    puts "here"
    puts @sp_for_location.to_s
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
        ticket_form.fields.create! :question => question, :field_type => "text"
        ticket_form.write_form
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
        ticket_form.fields.create! :question => question,
                                   :field_type => "radio", :options => options
        if ticket_form.write_form
          flash[:notice] = "New Field Added"        
          redirect_to ticket_form
        else
          flash[:error] = "Error: Unable to write form to file."    
          session[:field_question] = question  
          redirect_to new_form_field_path      
        end
      end
    end
end
