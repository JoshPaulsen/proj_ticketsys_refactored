require 'spec_helper'

describe TicketsController do
  render_views   
  
  describe "close action" do
    before :each do
      user = Factory(:user, :privilege=>"admin")
      test_sign_in(user)      
    end
    
    describe "if the ticket is not already closed" do
      before :each do
        @ticket = Factory(:ticket)
        @ticket.closed_on = nil       
        Ticket.stub(:find_by_id).with(@ticket.id.to_s).and_return @ticket
      end
    
      it "should set the closed on time of the ticket" do
        put :close, :id => @ticket.id
        assigns(:ticket).closed_on.should_not == nil
      end
      
      it "should display a success message and redirect to the my tickets path" do
        put :close, :id => @ticket.id
        flash[:success].should == "Ticket Closed"
        response.should redirect_to tickets_path
      end    
    end
    
    describe "if the ticket is already closed" do
      before :each do
        @ticket = Factory(:ticket)
        @ticket.closed_on = Time.now        
        Ticket.stub(:find_by_id).with(@ticket.id.to_s).and_return @ticket
      end
      
      it "should display an error" do
        put :close, :id => @ticket.id
        flash[:error].should == "That Ticket Is Already Closed"
      end
      
      it "should redirect back to the ticket" do
        put :close, :id => @ticket.id
        response.should redirect_to @ticket 
      end      
    end
  end
  
  describe "open action" do  
    before :each do
      user = Factory(:user, :privilege=>"admin")
      test_sign_in(user)      
    end  
    
    describe "if the ticket is closed" do
      before :each do
        @ticket = Factory(:ticket)
        @ticket.closed_on = Time.now     
        Ticket.stub(:find_by_id).with(@ticket.id.to_s).and_return @ticket
      end
    
      it "should remove the closed on time" do
        put :open, :id => @ticket.id
        assigns(:ticket).closed_on.should == nil
      end
      
      it "should display a success message and redirect to the ticket" do
        put :open, :id => @ticket.id
        flash[:success].should == "Ticket Reopened"
        response.should redirect_to @ticket
      end    
    end
    
    describe "if the ticket is already open" do
      before :each do
        @ticket = Factory(:ticket)
        @ticket.closed_on = nil        
        Ticket.stub(:find_by_id).with(@ticket.id.to_s).and_return @ticket
      end
      
      it "should display an error" do
        put :open, :id => @ticket.id
        flash[:error].should == "That Ticket Is Already Open"
      end
      
      it "should redirect back to the ticket" do
        put :open, :id => @ticket.id
        response.should redirect_to @ticket 
      end      
    end
  end
  
  
  describe "index action" do
    it "should should show an admin all of the tickets" do
      user = Factory(:user, :privilege=>"admin")
      ticket = Factory(:ticket)
      ticket.stub(:opened).and_return ticket
      test_sign_in(user)   
      user.should_receive(:tickets).and_return ticket    
      get :index      
    end
    
    it "should should show a service provider only their tickets" do
      user = Factory(:user, :privilege=>"service provider")
      test_sign_in(user)   
      
    end
    
  end
  
  describe "show action" do
    
    before :each do
      user = Factory(:user, :privilege=>"admin")
      test_sign_in(user)
      @ticket = Factory(:ticket)
      @notes = [Factory(:note), Factory(:note)]         
      @ticket.notes = @notes
    end
    
    describe "a ticket that exists" do
      
      it "should find the ticket notes so they can be rendered" do
        Ticket.should_receive(:find_by_id).with(@ticket.id.to_s).and_return @ticket
        get :show, :id => @ticket.id
        assigns(:notes).should == @notes.reverse
      end
      
    end
    
    describe "a ticket that does not exit" do      
     
      it "should display and error and redirect to the tickets path" do
        Ticket.should_receive(:find_by_id).with("3").and_return nil
        get :show, :id => 3      
        flash[:error].should == "That Ticket Does Not Exist: 3"
        response.should redirect_to tickets_path 
      end      
    end
  end
  
  
end
