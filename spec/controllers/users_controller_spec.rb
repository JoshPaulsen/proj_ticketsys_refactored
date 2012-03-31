require 'spec_helper'

describe UsersController do
  render_views

  before :each do
    user = Factory(:user, :privilege=>"admin")
    test_sign_in(user)   
  end
    
  describe "creating a new user" do    
    it "should display a success message and redirect to that user if successful" do
      user = Factory :user
      user.stub(:save).and_return true
      User.stub(:new).and_return user
      post :create
      flash[:notice].should == "New user successfully created"      
      response.should redirect_to user_path user
    end 
    
    it "should display an error if the user can not be created" do
      user = Factory :user
      user.stub(:save).and_return false
      User.stub(:new).and_return user
      post :create
      flash[:error].should == "Error: User could not be created!"
      response.should redirect_to new_user_path
    end       
  end
  
  describe "updating a user" do
    before :each do
      @user = Factory :user
      User.stub(:find).and_return @user
    end
    
    it "should display a success message and redirect back to the user if update succeeds" do      
      @user.stub(:save).and_return true      
      put :update, :id => @user.id      
      flash[:notice].should == "User Profile Updated"  
      response.should redirect_to user_path @user      
    end
    
    it "should display an error message and redirect back to the user if update fails" do     
      @user.stub(:save).and_return false     
      put :update, :id => @user.id      
      flash[:error].should == "User Profile could not be updated"      
      response.should redirect_to user_path @user      
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
      flash[:notice].should eq "User was deleted"
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
      flash[:error].should eq "That user does not exist"
      response.should redirect_to users_path    
    end
    
    
  end
  
  def show    
    @user = User.find_by_id(params[:id])
    if @user.nil?
      flash[:error] = "That user does not exist"
      redirect_to users_path    
    end    
  end  
  
end
