module Liquid
  module Tags

    # Filter a collection
    #
    # Usage:
    #
    # {% with_scope main_developer: 'John Doe', active: true %}
    #   {% for project in contents.projects %}
    #     {{ project.name }}
    #   {% endfor %}
    # {% endwith_scope %}
    #

    class WithScope < ::Liquid::Block

      TagAttributes = /(\w+|\w+\.\w+)\s*\:\s*(#{::Liquid::QuotedFragment})/

      def initialize(tag_name, markup, tokens)
        @attributes = HashWithIndifferentAccess.new

        markup.scan(TagAttributes) do |key, value|
          @attributes[key] = value unless key.eql?('render_tag')
        end

        if markup =~ /render_tag:([_a-z0-9]+)/
          @style = $1
        end

        super
      end

      def render(context)
        context.stack do
          result = render_all(@nodelist, context).join
        end

        context.stack do
          context['with_scope'] = decode(@attributes.clone, context)
          render_all(@nodelist, context)
        end
      end

      private

      def decode(attributes, context)
        attributes.each_pair do |key, value|
          attributes[key] = context[value]
        end
      end
    end

    ::Liquid::Template.register_tag('with_scope', WithScope)
  end
end
