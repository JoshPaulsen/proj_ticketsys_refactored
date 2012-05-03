require 'spec_helper'

describe UsersController do
  render_views

  before :each do
    user = Factory(:user, :privilege=>"admin")
    test_sign_in(user)   
  end
    
  describe "creating a new user" do
    
    
    
  end
  
  describe "updating a user" do
    before :each do
      @user = Factory :user
      User.stub(:find).and_return @user
    end
    
  end
  
  describe "edit method" do
    it "should assign a user to @user" do
      user = Factory :user
      User.stub(:find_by_id).and_return user
      get :edit, :id => user.id
      assigns[:user].should eq user
    end
  end
  
  describe "index method" do
    it "should assign all users to @users" do
      user1 = Factory :user
      user2 = Factory :user
      User.stub(:all).and_return [user1, user2]
      get :index
      assigns[:users].should eq [user1, user2]
    end
  end
  
  describe "deleting a user" do
    before :each do
      @user = Factory :user
      User.stub(:find_by_id).and_return @user
    end
    
    it "should destroy the user" do       
      @user.should_receive(:destroy) 
      delete :destroy, :id => @user.id     
    end
    
    it "should redirect to the main users path" do
      delete :destroy, :id => @user.id
      response.should redirect_to users_path
    end
    
    it "should display a message" do
      delete :destroy, :id => @user.id
      flash[:notice].should eq "User Was Deleted"
    end 
  end  
  
  describe "showing a user" do
    
    it "should assign the user to @user if the user can be found" do
      user = Factory :user
      User.stub(:find_by_id).and_return user
      get :show, :id => user.id
      assigns[:user].should eq user
    end
    
    it "should redirect to the main users path and display an error if the user does not exist" do
      User.stub(:find_by_id).and_return nil
      get :show, :id => ""
      flash[:error].should eq "That User Does Not Exist"
      response.should redirect_to users_path    
    end
  end
  
  describe "deactivating a user" do
    it "should return error if no user can be found" do
      User.stub(:find_by_id).and_return nil
      post :deactivate, :id => '1'
      flash[:error].should == "That User Does Not Exist"
      response.should redirect_to users_path
    end
    
    it "should leave a user deactivated if user is already deactivated" do
      user = Factory :user
      User.stub(:find_by_id).and_return user
      user.stub(:inactive?).and_return true
      post :deactivate, :id => user.id
      flash[:error].should == "That User Was Already Deactivated"
      response.should redirect_to users_path
    end
    
    it "should deactivate a user if it is active" do
      user = Factory :user
      User.stub(:find_by_id).and_return user
      user.stub(:inactive?).and_return false
      post :deactivate, :id => user.id
      flash[:notice].should == "User Deactivated"
      response.should redirect_to users_path
    end
  end
  
    describe "reactivating a user" do
    it "should return error if no user can be found" do
      User.stub(:find_by_id).and_return nil
      post :reactivate, :id => '1'
      flash[:error].should == "That User Does Not Exist"
      response.should redirect_to users_path
    end
    
    it "should leave a user active if user is already activated" do
      user = Factory :user
      User.stub(:find_by_id).and_return user
      user.stub(:active?).and_return true
      post :reactivate, :id => user.id
      flash[:error].should == "That User Is Currently Active"
      response.should redirect_to user
    end
    
    it "should reactivate a user if it is deactive" do
      user = Factory :user
      User.stub(:find_by_id).and_return user
      user.stub(:active?).and_return false
      post :reactivate, :id => user.id
      flash[:notice].should == "User Reactivated"
      response.should redirect_to user
    end
  end 
end



