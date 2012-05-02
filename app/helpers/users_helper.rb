module UsersHelper
  def valid_email?(email)
    #email =~ /[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/
    email.length > 0
  end
  
  def valid_password?(password)
    !password.blank? and password.length > 5   
  end
    
end
