class SettingsController < ApplicationController
  before_filter :check_if_signed_in
  before_filter :deny_user
  
  def index
  end
end
