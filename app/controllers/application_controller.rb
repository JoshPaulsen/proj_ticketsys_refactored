class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include TicketsHelper
  
  class TagHelper
    include Singleton
    include ActionView::Helpers::FormHelper
    #include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::FormTagHelper
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Helpers::FormOptionsHelper
  end
  
  def get_form_helper
    TagHelper.instance
  end
  
end
