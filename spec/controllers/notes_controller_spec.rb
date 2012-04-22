require 'spec_helper'

describe NotesController do
  render_views
  
  before :each do
    user = Factory(:user)
    test_sign_in(user)   
  end
    
  describe "creating a note" do     
    
    describe "for a ticket that is closed already" do
      it "should return an error indicating the ticket is closed" do
        ticket = Factory(:ticket, :closed_on => Time.now)      
        Ticket.stub(:find_by_id).with(ticket.id.to_s).and_return ticket
        post :create, :ticket_id => ticket.id
        flash[:error].should == "Error: A note cannot be added to a closed ticket"
        response.should redirect_to ticket_path(ticket)
      end
    end  
    
    describe "for a note without a body" do      
      it "should return an error indicating the note needs a body" do        
        ticket = Factory(:ticket, :closed_on => nil)      
        Ticket.stub(:find_by_id).with(ticket.id.to_s).and_return ticket
        post :create, :ticket_id => ticket.id, :user_id=>1
        flash[:error].should == "Error: Note cannot be blank"
        response.should redirect_to ticket_path(ticket)
      end      
    end 
    
    describe "for a valid note" do      
      it "should redirect to the ticket the note was for and there should not be an error" do
        ticket = Factory(:ticket, :closed_on => nil)      
        Ticket.stub(:find_by_id).with(ticket.id.to_s).and_return ticket
        post :create, :ticket_id => ticket.id, :user_id=>1, :note => {:body => "test"}
        flash[:error].should be_nil
        response.should redirect_to ticket_path(ticket)
      end
    end
    
    describe "for a note with an attached file" do
      it "should attach the file and redirect to the ticket the note was for and there should not be an error" do
        ticket = Factory(:ticket, :closed_on => nil)
        Ticket.stub(:find_by_id).with(ticket.id.to_s).and_return ticket
        post :create, :ticket_id => ticket.id, :user_id=>1, :note => {:body => "test"}, :attachment => File.new(Rails.root + 'spec/controllers/notes_controller_spec.rb')
        flash[:error].should be_nil
        response.should redirect_to ticket_path(ticket)
      end
    end
  end
end


  
