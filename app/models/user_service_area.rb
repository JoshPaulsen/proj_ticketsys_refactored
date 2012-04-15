class UserServiceArea < ActiveRecord::Base
  # user_id:integer
  # service_area_id:integer  
  
  belongs_to :user
  belongs_to :service_area
  validates_uniqueness_of :user_id, :scope => :service_area_id
end
