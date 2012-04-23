require 'spec_helper'

describe ServiceAreaFormsController do
  render_views

  before :each do
    user = Factory(:user, :privilege=>"admin")
    test_sign_in(user)      
  end
  
  describe "move up form" do
  
  end
  
  describe "move down form" do
  
  end
  
  describe "remove field from form" do
  
  end
  
  describe "set providers for form" do 
  
  end
  
  describe "create form" do
  
  end
  
  describe "new field for form" do
  
  end
  
  describe "destroy form" do
  
  end
  
  describe "create field for form" do
  
  end
  
end
