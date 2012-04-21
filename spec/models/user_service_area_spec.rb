require 'spec_helper'

describe UserServiceArea do
  before(:each) do
    @attr = {:user_id => 1, :service_area_id => 2}
  end
  
  describe "user, service area associations" do
    before(:each) do
      @usa = UserServiceArea.create!(@attr)
    end
    
    it "should respond to user" do
      @usa.should respond_to(:user)
    end
    
    it "should respond to service_area" do
      @usa.should respond_to(:service_area)
    end
    
  end

end
