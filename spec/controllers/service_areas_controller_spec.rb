require 'spec_helper'

describe ServiceAreasController do
  render_views
  
  describe "creating a new service area" do
    before :each do
      user = Factory(:user, :privilege=>"admin")
      test_sign_in(user)      
    end
    
    it "should redirect to the service area path" do
      fake_service_area = Factory :service_area
      fake_service_area.stub(:save).and_return true
      ServiceArea.stub(:new).and_return fake_service_area
      post :create, :service_area => fake_service_area
      response.should redirect_to service_areas_path
    end
    
    it "should error with a message" do
      fake_service_area = Factory :service_area
      fake_service_area.stub(:save).and_return false
      ServiceArea.stub(:new).and_return fake_service_area
      post :create, :service_area => fake_service_area
      flash[:error].should == "A Service Area with that name already exists"
      response.should redirect_to service_areas_path
    end
  end
end

