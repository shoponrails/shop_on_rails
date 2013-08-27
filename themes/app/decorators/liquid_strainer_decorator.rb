Liquid::Strainer.class_eval do
  include ActionView::Context
  include ActionView::Helpers

  include Rails.application.routes.url_helpers
  include Refinery::Core::Engine.routes.url_helpers
  include Spree::Core::Engine.routes.url_helpers

  include Spree::BaseHelper
  include Spree::ProductsHelper

  def initialize(context)
    @context = context
  end

  def controller
    @controller ||= @context.registers[:controller]
  end

  def action_view
    @action_view ||= @context.registers[:action_view]
  end

  delegate :request, :to => :controller
  delegate :params, :to => :request
  delegate  :capture, :to => :action_view
  delegate  :spree, :to => :action_view
  delegate  :refinery, :to => :action_view

end