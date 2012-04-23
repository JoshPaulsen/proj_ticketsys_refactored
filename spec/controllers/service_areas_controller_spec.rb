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
  
  describe "destroying a service area" do
    before :each do
      user = Factory(:user, :privilege=>"admin")
      test_sign_in(user)      
    end
    
    it "should redirect to service_areas_path" do
      fake_area = Factory :service_area
      fake_area.stub(:destroy)
      ServiceArea.stub(:fine_by_id).with(fake_area.id).and_return fake_area
      post :destroy, :id => fake_area.id
      flash[:notice].should == "Service Area was deleted"
      response.should redirect_to service_areas_path
    end
  end
  
  describe "editing a service area" do
    before :each do
      user = Factory(:user, :privilege=>"admin")
      test_sign_in(user)      
    end
    
    it "should redirect to service area" do
      fake_area = Factory :service_area
      ServiceArea.stub(:find_by_id).and_return fake_area
      post :edit, :id => fake_area.id
      redirect_to service_areas_path fake_area.id
    end
    
    it "should return an error and redirect to service area" do
      ServiceArea.stub(:find_by_id).with('1').and_return false
      post :edit, :id => '1'
      flash[:error] = "That service area does not exist"
      response.should redirect_to service_areas_path
    end
  end
  
  describe "update a service area" do
    before :each do
      user = Factory(:user, :privilege=>"admin")
      test_sign_in(user)
    end
    
    it "should save and redirect to service area" do
      fake_area = Factory :service_area
      ServiceArea.stub(:find_by_id).and_return fake_area
      fake_area.stub(:update_attributes)      
      fake_area.stub(:save).and_return true
      post :update, :id => fake_area.id, :service_area => fake_area
      flash[:notice].should == "Service Area Updated"
      response.should redirect_to service_areas_path
    end
      
    it "should not save and redirect to service area" do
      fake_area = Factory :service_area
      fake_area.stub(:update_attributes)  
      fake_area.stub(:save).and_return false
      ServiceArea.stub(:find_by_id).and_return fake_area
      post :update, :id => fake_area.id, :service_area => fake_area
      flash[:notice].should == "Service Area could not be updated"
      response.should redirect_to service_areas_path
    end
  end
  
  describe "deactiving a service area" do
    before :each do
      user = Factory(:user, :privilege=>"admin")
      test_sign_in(user)
    end
    
    it "should Error if no service can be found" do
      ServiceArea.stub(:find_by_id).and_return nil
      post :deactivate, :id => '1'
      flash[:error].should == "That service area does not exist"
      response.should redirect_to service_areas_path
    end
    
    it "should leave it deactivated if it already is deactivated" do
      fake_area = Factory :service_area
      ServiceArea.stub(:find_by_id).and_return fake_area
      fake_area.stub(:inactive?).and_return true
      post :deactivate, :id => fake_area.id
      flash[:error].should == "That service area was already deactivated"
      response.should redirect_to service_areas_path
    end
    
    it "should deactivate the service area" do
      fake_area = Factory :service_area
      ServiceArea.stub(:find_by_id).and_return fake_area
      fake_area.stub(:inactive?).and_return false
      post :deactivate, :id => fake_area.id
      flash[:notice].should == "Service Area Deactivated"
      response.should redirect_to service_areas_path
    end
  end
  
  describe "reactiving a service area" do
    before :each do
      user = Factory(:user, :privilege=>"admin")
      test_sign_in(user)
    end
    
    it "should Error if no service can be found" do
      ServiceArea.stub(:find_by_id).and_return nil
      post :reactivate, :id => '1'
      flash[:error].should == "That service area does not exist"
      response.should redirect_to service_areas_path
    end
    
    it "should leave it active if it already is activated" do
      fake_area = Factory :service_area
      ServiceArea.stub(:find_by_id).and_return fake_area
      fake_area.stub(:active?).and_return true
      post :reactivate, :id => fake_area.id
      flash[:error].should == "That service area is currently active"
      response.should redirect_to service_areas_path
    end
    
    it "should reactivate the service area" do
      fake_area = Factory :service_area
      ServiceArea.stub(:find_by_id).and_return fake_area
      fake_area.stub(:active?).and_return false
      post :reactivate, :id => fake_area.id
      flash[:notice].should == "Service Area Reactivated"
      response.should redirect_to service_areas_path
    end
  end
end

