class Rule < ActiveRecord::Base
  # provider_id:integer
  # form_id:integer
  # location_id:integer
  
  belongs_to :provider, :class_name => "User"
  belongs_to :form, :class_name => "ServiceAreaForm"
  belongs_to :location
  
end
