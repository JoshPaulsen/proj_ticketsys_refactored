class NotesController < ApplicationController
  
  before_filter :check_if_signed_in
  
  # Some of these can be removed along with the routes...
  def new
  end

  def create
    ticket = Ticket.find_by_id(params[:ticket_id])
    if ticket.closed?
      flash[:error] = "Error: A note cannot be added to a closed ticket"
      redirect_to ticket_path ticket and return      
    end
    @note = Note.new(params[:note])
    @note.user_id = params[:user_id]
    @note.ticket_id = params[:ticket_id]    
    if @note.save
      redirect_to ticket_path ticket
    else
      flash[:error] = "Error: Note could not be created"
      redirect_to ticket_path ticket
    end
  end

  def update
  end

  def edit
  end

  def destroy
  end

  def index
  end

  def show
    @note = Note.find_by_id(params[:id])
  end
end
