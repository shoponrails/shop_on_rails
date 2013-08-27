module Protected
  extend ERB::Util
  extend ActionView::Helpers
  extend ActionView::Helpers::UrlHelper
  extend ActionView::Helpers::TagHelper


  class << self
    include ActionDispatch::Routing
    include Rails.application.routes.url_helpers
    include Refinery::Core::Engine.routes.url_helpers
    include Spree::Core::Engine.routes.url_helpers

    def config=(controller)
      @controller = controller
    end

    def config
      @controller
    end

    def controller
      @controller
    end
  end

end
