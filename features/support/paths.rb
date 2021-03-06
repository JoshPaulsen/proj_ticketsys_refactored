# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'
    
    when /^the Ticket View page$/
      '/tickets'    
    
    when /^the tickets page$/i
      tickets_path
      
    when /^the new ticket page$/i
      new_ticket_path
      
    when /^the login page$/i
      signin_path
      
    when /^the sign in page$/i
      signin_path      
      
    when /^the admin home page$/i
      tickets_path
      
    when /^the new ticket page$/i
      new_ticket_path
      
    when /^the my tickets page$/i
      my_tickets_path
      
    when /^the continue new ticket page$/i
      continue_new_ticket_path    
    
    when /^the service areas page$/i
      service_areas_path  
      
    when /^the service area forms page$/i
      service_area_forms_path  
      
    when /^the locations page$/i
      locations_path  
    #when /^\/tickets\/(.*)$/
      #tickets_path(1)

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
