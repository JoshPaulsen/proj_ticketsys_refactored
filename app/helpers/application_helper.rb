module ApplicationHelper  
  
  # Most of these functions are used in forms
  
  def get_departments
    ["IT", "HR", "Facilities"]
  end
  
  def get_service_areas    
    service_areas = ServiceArea.all.collect do |sa|
      [sa.name, sa.id]
    end    
  end
  
  def get_privileges
    ["user", "service provider", "admin"]
  end
  
  def get_categories_for(department)
    categories = TicketForm.where(:department => department).collect do |tf|
      [tf.category, tf.id]
    end
  end
  
  def get_all_categories
    categories = TicketForm.all.collect do |tf|  
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
  
  # Returns a list of lists of the providers and their ids in the given department  
  def get_providers_in(department)
    p = User.where(:department => department, :privilege => "service provider").collect do |prov|
      [prov.name, prov.id]
    end
  end
  
  # Returns a list of lists of all of the watchers of a ticket  
  def get_watchers_for(ticket)
    u = ticket.just_watchers.collect do |user|
      [user.name, user.id]
    end
  end
  
  
  
  
end
