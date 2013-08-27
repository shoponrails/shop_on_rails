class ActionView::Helpers::FormBuilderDrop < Liquid::BaseDrop

  def self.included
    include Rails.application.routes.url_helpers
  end

  def text_field(options)
    @source.text_field(options['method'], options.except('method'))
  end

  def number_field(options)
    @source.number_field(options['method'], options.except('method'))
  end

end