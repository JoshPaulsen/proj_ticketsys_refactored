require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = {:name => "Josh", :password => "pw", :privilege => "admin",
              :email => "j@j.com", :location => "home", :department => "IT"}    
  end
  
  it "should create a new user" do
    User.create!(@attr)
  end
  
  it "should require a username" do
    user = User.new(@attr.merge(:name =>""))
    user.should_not be_valid
  end
  
  it "should require a password" do
    user = User.new(@attr.merge(:password =>""))
    user.should_not be_valid
  end
  
  it "should require a privilege" do
    user = User.new(@attr.merge(:privilege =>""))
    user.should_not be_valid
  end
  
  it "should require a privilege" do
    user = User.new(@attr.merge(:email =>""))
    user.should_not be_valid
  end
  
  it "should require that the user name be unique" do
    User.new(@attr).save
    user = User.new(@attr.merge(:email =>"not j@j.com"))
    user.should_not be_valid
  end
  
  it "should require that the email be unique" do
    User.new(@attr).save
    user = User.new(@attr.merge(:name =>"not Josh"))
    user.should_not be_valid
  end
  
  describe "boolean privilege methods for" do
    
    describe "a user" do
      
      before(:each) do
        @user = User.create!(@attr.merge(:privilege => "user"))
      end
      
      it "should return true for user?" do
        @user.user?.should be_true
      end
      
      it "should return false for service_provider?" do
        @user.service_provider?.should be_false
      end
      
      it "should return false for admin?" do
        @user.admin?.should be_false
      end
      
    end   
    
    describe "a service provider" do
      
      before(:each) do
        @sp = User.create!(@attr.merge(:privilege => "service provider"))
      end
      
      it "should return false for user?" do
        @sp.user?.should be_false
      end
      
      it "should return true for service_provider?" do
        @sp.service_provider?.should be_true
      end
      
      it "should return false for admin?" do
        @sp.admin?.should be_false
      end
      
    end   
    
    describe "an admin" do
      
      before(:each) do
        @a = User.create!(@attr.merge(:privilege => "admin"))
      end
      
      it "should return false for user?" do
        @a.user?.should be_false
      end
      
      it "should return false for service_provider?" do
        @a.service_provider?.should be_false
      end
      
      it "should return true for admin?" do
        @a.admin?.should be_true
      end
      
    end
    
  end
  
  describe "returning the next service provider" do    
    
    it "should return an IT provider if the department is IT" do
      User.create!(@attr.merge(:privilege => "service provider", :department=>"IT"))
      sp = User.next_provider("IT")
      sp.department.should == "IT"
    end
    
    it "should return an HR provider if the department is HR" do
      User.create!(@attr.merge(:privilege => "service provider", :department=>"HR"))
      sp = User.next_provider("HR")
      sp.department.should == "HR"
    end
    
  end
  
end