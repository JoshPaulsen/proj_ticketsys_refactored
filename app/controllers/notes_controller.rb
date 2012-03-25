class NotesController < ApplicationController
  
  before_filter :check_if_signed_in
  
  def new
  end

  def create
    
    @note = Note.new(params[:note])
    @note.user_id = params[:user_id]
    @note.ticket_id = params[:ticket_id]
    ticket = Ticket.find_by_id(params[:ticket_id])
    if @note.save
      redirect_to ticket_path ticket
    else
      flash.now[:error] = "Note could not be created"
      render "new"
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
