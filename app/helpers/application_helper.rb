module ApplicationHelper  
  
  # Most of these functions are used in forms
  
  
  def get_service_areas
    sa = ServiceArea.all.collect do |s|
      [s.name, s.id]
    end
  end
  
  def get_privileges
    ["user", "service provider", "admin"]
  end
  
  def get_all_categories
    categories = ServiceAreaForm.all.collect do |tf|  
      c = ServiceArea.find_by_name tf.department    
      [tf.category, tf.id,{:class => c.id}]
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
    p = service_area.users.collect do |prov|
      [prov.name, prov.id]
    end
  end 
  
  def get_all_users
    User.all.collect do |user|
      [user.name, user.id]
    end
  end
  
  def get_additional_users_for(ticket)
    u = ticket.additional_users.collect do |user|
      [user.name, user.id]
    end
  end
    
  def get_additional_providers_for(ticket)
    u = ticket.additional_providers.collect do |user|
      [user.name, user.id]
    end
  end
  
  
  
end
