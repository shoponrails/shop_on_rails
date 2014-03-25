Liquid::Tag.class_eval do
  include Clot::TagHelper
  include Spree::BaseHelper

  def initialize(tag_name, markup, options)
    unless markup.nil?
      @attributes = {}
      markup.scan(Liquid::TagAttributes) do |key, value|
        @attributes[key] = value
      end
    end

    @tag_name   = tag_name
    @markup     = markup
    @options    = options
    parse(options)
  end


  def render(context)
    @result ||= ''
    context['capture_variable'] ? context.environments.first[context['capture_variable']] = @result : @result
  end
end