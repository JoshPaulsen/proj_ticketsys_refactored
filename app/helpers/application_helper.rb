module ApplicationHelper  
  
  # Most of these functions are used in forms 
  def get_locations
    loc = Location.all.collect do |l|
      [l.name, l.id]
    end
  end
  
  def get_active_locations
    loc = Location.active.collect do |l|
      [l.name, l.id]
    end
  end
  
  def get_service_areas
    sa = ServiceArea.all.collect do |s|
      [s.name, s.id]
    end
  end
  
  def get_service_areas_for(provider)
    sa = ServiceArea.where("id IN  #{provider.service_area_ids_to_s}").collect do |s|
      [s.name, s.id]
    end
  end
  
  def get_active_service_areas
    sa = ServiceArea.active.collect do |s|
      [s.name, s.id]
    end
  end
  
  def get_privileges
    ["user", "service provider", "admin"]
  end
  
  def get_all_types
    types = ServiceAreaForm.all.collect do |saf|
      [saf.title, saf.id,{:class => saf.service_area_id}]
    end
  end
  
  def get_all_types_for_search
    types = ServiceAreaForm.all.collect do |saf|
      [saf.title, saf.id]
    end
  end
  
  def readable_date(time)
    if time
      #time_ago_in_words(time)
      #distance_of_time_in_words_to_now(time)
      time.strftime("%a, %b %d, %Y at %I:%M%p")
    else
      nil
    end
  end
  
  # Returns a list of lists of the providers and their ids in the given service area  
  def get_providers_in(service_area)
    if !service_area.blank?
      p = service_area.users.collect do |prov|
        [prov.last_first_initial, prov.id]
      end
    end
  end 
  
  def get_providers_for(ticket)
    if !ticket.service_area.blank?
      p = ticket.service_area.users.active.collect do |prov|
        [prov.last_first_initial, prov.id]
      end
    end
  end 
  
  def get_all_users
    User.all.collect do |user|
      [user.last_first_initial, user.id]
    end
  end 
  
  def get_all_active_users
    User.active.collect do |user|
      [user.last_first_initial, user.id]
    end
  end 
  
  def get_remove_users_for(ticket)
    u = ticket.additional_users.collect do |user|
      [user.last_first_initial, user.id]
    end
  end 
  
  def get_remove_providers_for(ticket)
    u = ticket.additional_providers.collect do |user|
      [user.last_first_initial, user.id]
    end
  end
  
  def type_checked?(value)
    @type == value
  end
  
  def all_mine_checked?(value)
    @all_mine == value
  end
  
  def service_area_checked?(id)
    if @service_areas_list
      @service_areas_list.include? id
    else
      true
    end
  end
  
  
  
end
