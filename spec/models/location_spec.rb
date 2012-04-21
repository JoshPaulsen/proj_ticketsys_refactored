require 'spec_helper'

describe Location do
  
  before(:each) do
    @attr = {:name => "IT", :address => "123 Street", :active => true}
  end
  
  describe "rules associations" do
    before(:each) do
      @loc = Location.create!(@attr)
    end
    
    it "should respond to users" do
      @loc.should respond_to(:rules)
    end   
  end
  
  describe "if they are active" do
    before(:each) do
      @loc = Location.create!(@attr.merge(:active => true))
    end 
    
    it "should return true for active?" do
      @loc.active?.should be_true
    end
    
    it "should return false for inactive?" do
      @loc.inactive?.should be_false    
    end
  end 
    
  describe "if they are inactive" do
    before(:each) do
      @loc = Location.create!(@attr.merge(:active => false))
    end 
    
    it "should return false for active?" do
      @loc.active?.should be_false
    end
    
    it "should return true for inactive?" do
      @loc.inactive?.should be_true    
    end
  end  
  
end