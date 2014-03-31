class RenderRSS < Liquid::Block

  def initialize(tag_name, markup, options)
    super
    @markup =  markup
    @attributes = {}
    markup.scan(Liquid::TagAttributes) do |key, value|
      @attributes[key] = value
    end

    RestClient.get(@attributes['source']).force_encoding('UTF-8')
    @parsed_rss = SimpleRSS.parse(rss_data)
  end

  def render(context)
    rss_reg = {
        "title" => @parsed_rss.title,
        "items" => @parsed_rss.items.map{|u| u.stringify_keys}
    }
    context.stack do
      context['feed'] = rss_reg
      render_all(@nodelist, context)
    end
  end
end

Liquid::Template.register_tag('rss', RenderRSS)