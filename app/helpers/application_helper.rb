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
  
end
