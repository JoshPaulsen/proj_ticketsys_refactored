require 'spec_helper'

describe LocationsController do
  render_views
  
  describe "creating a new location" do
    before :each do
      user = Factory(:user, :privilege=>"admin")
      test_sign_in(user)      
    end
    
    it "should redirect to the locations path" do
      fake_location = Factory :location
      fake_location.stub(:save).and_return true
      Location.stub(:new).and_return fake_location
      post :create, :location => fake_location
      flash[:notice].should == "New Location Added"
      response.should redirect_to locations_path
    end
    
    it "should error with a message" do
      fake_location = Factory :location
      fake_location.stub(:save).and_return false
      Location.stub(:new).and_return fake_location
      post :create, :location => fake_location
      flash[:error].should == "A Location with that name already exists"
      response.should redirect_to locations_path
    end
  end
  
  describe "destroying a location" do
    before :each do
      user = Factory(:user, :privilege=>"admin")
      test_sign_in(user)      
    end
    
    it "should redirect to locations_path" do
      fake_area = Factory :location
      fake_area.stub(:destroy)
      Location.stub(:fine_by_id).with(fake_area.id).and_return fake_area
      post :destroy, :id => fake_area.id
      flash[:notice].should == "Location was deleted"
      response.should redirect_to locations_path
    end
  end
  
  describe "editing a location" do
    before :each do
      user = Factory(:user, :privilege=>"admin")
      test_sign_in(user)      
    end
    
    it "should redirect to locations" do
      fake_area = Factory :location
      Location.stub(:find_by_id).and_return fake_area
      post :edit, :id => fake_area.id
      redirect_to locations_path fake_area.id
    end
    
    it "should return an error and redirect to location area" do
      Location.stub(:find_by_id).with('1').and_return false
      post :edit, :id => '1'
      flash[:error] = "That location does not exist"
      response.should redirect_to locations_path
    end
  end
  
  describe "update a location" do
    before :each do
      user = Factory(:user, :privilege=>"admin")
      test_sign_in(user)
    end
    
    it "should save and redirect to location" do
      fake_area = Factory :location
      Location.stub(:find_by_id).and_return fake_area
      fake_area.stub(:update_attributes)      
      fake_area.stub(:save).and_return true
      post :update, :id => fake_area.id, :location => fake_area
      flash[:notice].should == "Location Updated"
      response.should redirect_to locations_path
    end
      
    it "should not save and redirect to location" do
      fake_area = Factory :location
      fake_area.stub(:update_attributes)  
      fake_area.stub(:save).and_return false
      Location.stub(:find_by_id).and_return fake_area
      post :update, :id => fake_area.id, :location => fake_area
      flash[:notice].should == "Location could not be updated"
      response.should redirect_to locations_path
    end
  end
  
  describe "deactiving a location" do
    before :each do
      user = Factory(:user, :privilege=>"admin")
      test_sign_in(user)
    end
    
    it "should Error if no location can be found" do
      Location.stub(:find_by_id).and_return nil
      post :deactivate, :id => '1'
      flash[:error].should == "That location does not exist"
      response.should redirect_to locations_path
    end
    
    it "should leave it deactivated if it already is deactivated" do
      fake_area = Factory :location
      Location.stub(:find_by_id).and_return fake_area
      fake_area.stub(:inactive?).and_return true
      post :deactivate, :id => fake_area.id
      flash[:error].should == "That location was already deactivated"
      response.should redirect_to locations_path
    end
    
    it "should deactivate the location" do
      fake_area = Factory :location
      Location.stub(:find_by_id).and_return fake_area
      fake_area.stub(:inactive?).and_return false
      post :deactivate, :id => fake_area.id
      flash[:notice].should == "Location Deactivated"
      response.should redirect_to locations_path
    end
  end
  
  describe "reactiving a location" do
    before :each do
      user = Factory(:user, :privilege=>"admin")
      test_sign_in(user)
    end
    
    it "should Error if no location can be found" do
      Location.stub(:find_by_id).and_return nil
      post :reactivate, :id => '1'
      flash[:error].should == "That location does not exist"
      response.should redirect_to locations_path
    end
    
    it "should leave it active if it already is activated" do
      fake_area = Factory :location
      Location.stub(:find_by_id).and_return fake_area
      fake_area.stub(:active?).and_return true
      post :reactivate, :id => fake_area.id
      flash[:error].should == "That location is currently active"
      response.should redirect_to locations_path
    end
    
    it "should reactivate the location" do
      fake_area = Factory :location
      Location.stub(:find_by_id).and_return fake_area
      fake_area.stub(:active?).and_return false
      post :reactivate, :id => fake_area.id
      flash[:notice].should == "Location Reactivated"
      response.should redirect_to locations_path
    end
  end
end

