class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include TicketsHelper
  
  class TagHelper
    include Singleton
    include ActionView::Helpers::FormHelper
    #include ActionView::Helpers::TagHelper
    include ActionView::Helpers::AssetTagHelper
  end
  
  def get_tag_helper
    TagHelper.instance
  end
  
end
