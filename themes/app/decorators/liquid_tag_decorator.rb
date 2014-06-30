# require 'clot/tag_helper'
Liquid::Tag.class_eval do
  include Clot::TagHelper

  def render(context)
    @result ||= ''
    context['capture_variable'] ? context.environments.first[context['capture_variable']] = @result : @result
  end
end