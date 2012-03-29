require 'spec_helper'

describe Ticket do
  
  before(:each) do
    @attr = {:creator_id => 1, :provider_id => 2, :title=> "Test", :description => "fix me",
             :location => "office", :department => "IT", :opened_on => Time.now, 
             :closed_on => Time.now}
  end
  
  it "should create an new Ticket" do
    Ticket.create!(@attr)
  end
  
  it "should require a title" do
    ticket = Ticket.new(@attr.merge(:title =>""))
    ticket.should_not be_valid
  end
  
  it "should require an opened at time" do
    ticket = Ticket.new(@attr.merge(:opened_on =>nil))
    ticket.should_not be_valid
  end
  
  describe "boolean methods for" do
    
    describe "a ticket with a closed_on date" do
      before(:each) do
        @ticket = Ticket.create!(@attr.merge(:closed_on => Time.now))
      end
            
      it "should return true for closed?" do
        @ticket.closed?.should be_true
      end
      
      it "should return false for open?" do
        @ticket.open?.should be_false
      end
      
    end
    
    describe "a ticket without a closed_on date" do
      before(:each) do
        @ticket = Ticket.create!(@attr.merge(:closed_on => nil))
      end
            
      it "should return false for closed?" do
        @ticket.closed?.should be_false
      end
      
      it "should return true for open" do
        @ticket.open?.should be_true
      end
      
    end
    
  end
  
end