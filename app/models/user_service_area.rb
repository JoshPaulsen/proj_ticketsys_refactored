class UserServiceArea < ActiveRecord::Base
  belongs_to :user
  belongs_to :service_area
  validates_uniqueness_of :user_id, :scope => :service_area_id
end
