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
      flash[:error].should == "A Service Area With That Name Already Exists"
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
      flash[:notice].should == "Service Area Was Deleted"
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
      flash[:error] = "That Service Area Does Not Exist"
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
      flash[:notice].should == "Service Area Could Not Be Updated"
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
      flash[:error].should == "That Service Area Does Not Exist"
      response.should redirect_to service_areas_path
    end
    
    it "should leave it deactivated if it already is deactivated" do
      fake_area = Factory :service_area
      ServiceArea.stub(:find_by_id).and_return fake_area
      fake_area.stub(:inactive?).and_return true
      post :deactivate, :id => fake_area.id
      flash[:error].should == "That Service Area Was Already Deactivated"
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
      flash[:error].should == "That Service Area Does Not Exist"
      response.should redirect_to service_areas_path
    end
    
    it "should leave it active if it already is activated" do
      fake_area = Factory :service_area
      ServiceArea.stub(:find_by_id).and_return fake_area
      fake_area.stub(:active?).and_return true
      post :reactivate, :id => fake_area.id
      flash[:error].should == "That Service Area Is Currently Active"
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

