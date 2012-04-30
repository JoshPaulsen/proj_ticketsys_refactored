class NotesController < ApplicationController
  
  before_filter :check_if_signed_in
  
  def new
  end
  
  
  def create
    ticket = Ticket.find_by_id(params[:ticket_id])
    if ticket.closed?
      flash[:error] = "A note cannot be added to a closed ticket"
      redirect_to ticket_path ticket and return      
    end
    @note = Note.new(params[:note])
    @note.user_id = params[:user_id]
    @note.ticket_id = params[:ticket_id]    
    #@note.attachment = params[:]
    if @note.save
      redirect_to ticket_path ticket
    else
      flash[:error] = "Note cannot be blank"
      redirect_to ticket_path ticket
    end
  end
  
end
