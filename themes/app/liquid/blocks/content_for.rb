module Liquid

  # The content_for method allows you to insert content into a yield block in your layout. 
  # You only use content_for to insert content in named yields. 
  # 
  # In your layout:
  #  <title>{{ content_for title }}</title>
  #
  # In the view:
  #  {% content_for_title %} The title {% end_content_for_title %}
  #
  #
  # Will produce:
  #  <title>The title</title>
  #
  #
  class ContentFor < Liquid::Block
    SyntaxHelp = "Syntax Error in tag 'content_for' - Valid syntax: content_for_[name]"

    def initialize(tag_name, markup, options)
      if markup =~ /(#{VariableSignature}+)/
        @name = $1
      else
        raise SyntaxError.new(SyntaxHelp)
      end

      super
    end

    def render(context)
      result = ''

      context.stack do
        result = render_all(@nodelist, context)
      end

      context.registers[:action_view].view_flow.content[@name] = '' unless context.registers[:action_view].view_flow.content.has_key? @name

      context.registers[:action_view].view_flow.content[@name].concat(result.html_safe)

      ''

    end

    def block_delimiter
      "end_#{block_name}"
    end

  end
end

Liquid::Template.register_tag('content_for', Liquid::ContentFor)