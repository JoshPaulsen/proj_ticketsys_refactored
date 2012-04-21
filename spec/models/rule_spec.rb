require 'spec_helper'

describe Rule do
  
  before(:each) do
    @attr = {:provider_id => 1, :form_id => 1, :location_id => 1}
  end
  
  describe "provider, form and location associations" do
    before(:each) do
      @rule = Rule.create!(@attr)
    end
    
    it "should respond to provider" do
      @rule.should respond_to(:provider)
    end 
    
    it "should respond to form" do
      @rule.should respond_to(:form)
    end   
    
    it "should respond to provider" do
      @rule.should respond_to(:location)
    end     
  end
end
