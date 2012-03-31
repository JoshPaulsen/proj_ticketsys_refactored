require 'spec_helper'

describe Issue do
  
  before(:each) do
    @attr = {:user_id => 1, :ticket_id => 1}
  end
  
  it "should create a new note" do
    Issue.create!(@attr)
  end
  
  it "should respond to user" do
    issue = Issue.create!(@attr)
    issue.should respond_to(:user)
  end
  
  it "should respond to ticket" do
    issue = Issue.create!(@attr)
    issue.should respond_to(:ticket)
  end
  
end
