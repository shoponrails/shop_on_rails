module Liquid

  # Capture stores the result of a block into a variable without rendering it inplace.
  #
  #   {% capture_variable heading %}
  #     {% my_tag param1:value1 param2:value2 %}
  #   {% endcapture_variable %}
  #   ...
  #   <h1>{{ heading }}</h1>
  #
  # CaptureVariable is useful for saving variable (such as arrays, hashes) for use later in your template.
  #
  class CaptureVariable < Block
    Syntax = /(\w+)/

    def initialize(tag_name, markup, options)
      if markup =~ Syntax
        @to = $1
      else
        raise SyntaxError.new("Syntax Error in 'capture_variable' - Valid syntax: capture_variable [var]")
      end

      super
    end

    def render(context)
      context.scopes.last['capture_variable'] = @to
      render_all(@nodelist, context)
      if  context[@to].nil? and !@nodelist.empty?
        context[@to] = context[@nodelist.first.name]
      end
      context.scopes.last.except!('capture_variable')
      ''
    end
  end

  Template.register_tag('capture_variable', CaptureVariable)
end
