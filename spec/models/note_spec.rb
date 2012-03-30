require 'spec_helper'

describe Note do
  
  before(:each) do
    @attr = {:body => "test", :user_id => 1, :ticket_id => 1, :hidden => false}
  end
  
  it "should create a new note" do
    Note.create!(@attr)
  end
  
  it "should require a body" do
    note = Note.new(@attr.merge(:body =>""))
    note.should_not be_valid
  end
  
  it "should require a user ID" do
    note = Note.new(@attr.merge(:user_id => nil))
    note.should_not be_valid
  end
  
  it "should require a ticket ID" do
    note = Note.new(@attr.merge(:ticket_id => nil))
    note.should_not be_valid
  end
  
  it "should respond to hidden?" do
    note = Note.create!(@attr.merge(:hidden => true))
    note.hidden?.should be_true
  end
  
end
