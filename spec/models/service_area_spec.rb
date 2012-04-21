require 'spec_helper'

describe ServiceArea do
  
  before(:each) do
    @attr = {:name => "IT", :description => "Stuff", :active => true}
  end
  
  describe "tickets, user service area and users associations" do
    before(:each) do
      @sa = ServiceArea.create!(@attr)
    end
    
    it "should respond to users" do
      @sa.should respond_to(:users)
    end
    
    it "should respond to service_area" do
      @sa.should respond_to(:user_service_areas)
    end
    
    it "should respond to tickets" do
      @sa.should respond_to(:tickets)
    end
  end
  
  describe "if they are active" do
    before(:each) do
      @sa = ServiceArea.create!(@attr.merge(:active => true))
    end 
    
    it "should return true for active?" do
      @sa.active?.should be_true
    end
    
    it "should return false for inactive?" do
      @sa.inactive?.should be_false    
    end
  end 
    
  describe "if they are inactive" do
    before(:each) do
      @sa = ServiceArea.create!(@attr.merge(:active => false))
    end 
    
    it "should return false for active?" do
      @sa.active?.should be_false
    end
    
    it "should return true for inactive?" do
      @sa.inactive?.should be_true    
    end
  end  
  
end
