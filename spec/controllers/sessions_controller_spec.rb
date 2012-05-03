require 'spec_helper'

describe SessionsController do
  render_views
  
  describe "creating a new session (signing in)" do
    
    it "should return an error if the user name does not exist" do
      user = Factory :user
      Ticket.stub(:find_by_name).with(user.name).and_return nil
      post :create, :name => user.name, :password=>"xxx"
      flash[:error].should == "Invalid Username/Password"
      response.should redirect_to signin_path      
    end   
    
    
  end
  
  describe "destroying a session (signing out)" do
    
    it "should sign out the user" do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.signed_in?.should be_false      
    end    
    
   
  end
  
  describe "going to the sign in page when already signed in" do
    
    it "should redirect to the tickets path" do
      test_sign_in(Factory(:user))
      get :new
      response.should redirect_to tickets_path      
    end
  end
end
