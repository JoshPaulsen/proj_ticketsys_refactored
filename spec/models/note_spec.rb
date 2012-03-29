require 'spec_helper'

describe Note do
  
  before(:each) do
    @attr = {:body => "test", :user_id => 1, :ticket_id => 1, :hidden => false}
  end
  
  it "should create a new note" do
    Note.create!(@attr)
  end
  
  it "should require a body" do
    user = Note.new(@attr.merge(:body =>""))
    user.should_not be_valid
  end
  
  it "should require a user ID" do
    user = Note.new(@attr.merge(:user_id => nil))
    user.should_not be_valid
  end
  
  it "should require a ticket ID" do
    user = Note.new(@attr.merge(:ticket_id => nil))
    user.should_not be_valid
  end
end
