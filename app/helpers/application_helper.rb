module ApplicationHelper  
  def get_departments
    ["IT", "HR", "Facilities"]
  end
  
  def get_privileges
    ["user", "service provider", "admin"]
  end
  
  def readable_date(date)
    if !date.nil?
      date.strftime("%a, %b %d, %Y at %I:%M%p")
    else
      nil
    end
  end
  
  def get_providers_in(department)
    p = User.where(:department => department, :privilege => "service provider").collect do |prov|
      [prov.name, prov.id]
    end
  end
  
  def get_watchers_for(ticket)
    u = ticket.just_watchers.collect do |user|
      [user.name, user.id]
    end
  end
  
  
  
  
end
