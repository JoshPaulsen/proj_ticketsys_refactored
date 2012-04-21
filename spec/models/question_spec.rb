require 'spec_helper'

describe Question do
  
  # ticket_id:integer
  # question:string  
  # answer:text
  # position:integer
  
  before(:each) do
    @attr = {:ticket_id => 1, :question => "What?", :answer => "Nothing", :position => 1}
  end
  
  describe "ticket associations" do
    before(:each) do
      @question = Question.create!(@attr)
    end
    
    it "should respond to provider" do
      @question.should respond_to(:ticket)
    end 
    
  end
  
end
