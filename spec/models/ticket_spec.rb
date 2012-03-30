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
  
  describe "user, creator, provider associations" do
    before(:each) do
      @ticket = Ticket.create!(@attr)
    end
    
    it "should respond to users" do
      @ticket.should respond_to(:users)
    end
    
    it "should respond to creator" do
      @ticket.should respond_to(:creator)
    end
    
    it "should respond to provider" do
      @ticket.should respond_to(:provider)
    end
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
  
  describe "adding a watcher to a ticket" do
    
    before(:each) do
      @ticket = Ticket.create!(@attr.merge(:closed_on => nil))
      @user = Factory(:user)
    end
    
    describe "by user" do
      
      it "should return the user" do
        @ticket.add_watcher @user 
        @ticket.users.should include @user
      end      
    end
    
    describe "by user ID" do
      
      it "should return the user" do
        @ticket.add_watcher_by_id @user.id
        @ticket.users.should include @user
      end            
    end    
  end
  
  describe "removing a watcher from a ticket" do
    before(:each) do
      @ticket = Ticket.create!(@attr) 
      @user = Factory(:user)
      @ticket.add_watcher @user
    end
    
    describe "by user" do
      
      it "should not return the user" do
        @ticket.remove_watcher @user 
        @ticket.users.should_not include @user
      end      
    end
    
    describe "by user ID" do
      
      it "should not return the user" do
        @ticket.remove_watcher_by_id @user.id 
        @ticket.users.should_not include @user
      end            
    end  
  end
  
  describe "setting the creator" do
    
    describe "when a ticket does not have one" do
      before(:each) do
        @ticket = Ticket.create!(@attr.merge(:creator_id => nil)) 
        @user = Factory(:user)        
      end
      
      it "should return nil for creator" do
        @ticket.creator.should be_nil
      end
      
      it "should return the creator after it is set" do
        @ticket.set_creator @user
        @ticket.creator.should == @user
      end
      
      it "should contain the creator in users after it is set" do
        @ticket.set_creator @user
        @ticket.users.should include @user
      end      
    end
    
    describe "when a ticket already has one" do
      before(:each) do
        @oldcreator = Factory(:user)
        @ticket = Ticket.create!(@attr)
        @ticket.set_creator @oldcreator 
        @newcreator = Factory(:user)        
      end
      
      it "should return the new creator after it is set" do
        @ticket.set_creator @newcreator
        @ticket.creator.should == @newcreator
      end
      
      it "should not include the old creator in its users after a new creator is set" do
        @ticket.set_creator @newcreator
        @ticket.users.should_not include @oldcreator
      end
    end
  end
  
  describe "setting the provider" do
    
    describe "when a ticket does not have one" do
      before(:each) do
        @ticket = Ticket.create!(@attr.merge(:creator_id => nil)) 
        @user = Factory(:user)        
      end
      
      it "should return nil for provider" do
        @ticket.provider.should be_nil
      end
      
      it "should return the creator after it is set" do
        @ticket.set_provider @user
        @ticket.provider.should == @user
      end
      
      it "should contain the creator in users after it is set" do
        @ticket.set_provider @user
        @ticket.users.should include @user
      end      
    end
    
    describe "when a ticket already has one" do
      before(:each) do
        @oldp = Factory(:user)
        @ticket = Ticket.create!(@attr)
        @ticket.set_provider @oldp 
        @newp = Factory(:user)        
      end
      
      it "should return the new provider after it is set" do
        @ticket.set_provider @newp
        @ticket.provider.should == @newp
      end
      
      it "should not include the old provider in its users after a new provider is set" do
        @ticket.set_provider @newp
        @ticket.users.should_not include @oldp
      end
    end
  end
  
  describe "returning just the watchers and not the creator or provider" do
    before(:each) do
      @c = Factory(:user)
      @p = Factory(:user)  
      @w1 = Factory(:user)  
      @w2 = Factory(:user)   
      @ticket = Ticket.create!(@attr)
      @ticket.set_creator @c
      @ticket.set_provider @p         
    end
    
    it "should return nothing if there are no users attached except the creator and provider" do
      @ticket.just_watchers.should be_blank
    end
    
    it "should only return the watchers and not the creator or provider" do
      @ticket.add_watcher @w1
      @ticket.just_watchers.should include @w1
      @ticket.just_watchers.should_not include @c
      @ticket.just_watchers.should_not include @p      
    end
    
    it "should return all watchers" do
      @ticket.add_watcher @w1
      @ticket.add_watcher @w2
      @ticket.just_watchers.should include @w1      
      @ticket.just_watchers.should include @w2
    end
    
    
    
  end
  
  
  
end