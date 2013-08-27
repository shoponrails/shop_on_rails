# original: https://gist.github.com/4605222
# variants:
# https://gist.github.com/4605162
#
class ActionView::Template::Handlers::Liquid

  def self.call(template)
    "ActionView::Template::Handlers::Liquid.new(self).render(#{template.source.inspect}, local_assigns)"
  end

  def initialize(view)
    @view = view
  end

  def render(template, local_assigns = {})
    @view.controller.headers["Content-Type"] ||= 'text/html; charset=utf-8'

    assigns = @view.assigns.update('view' => @view)
    assigns['site_name'] = Refinery::Core.site_name
    assigns['theme_assigns'] = Refinery::Themes::Theme.current_theme_config['assigns']
    assigns['theme_config'] = Refinery::Themes::Theme.current_theme_config['config']
    assigns['spree_config'] = Spree::Config

    assigns.merge!(local_assigns.stringify_keys)

    @view.controller._helpers.instance_methods.each do |method|
      assigns[method.to_s] = Proc.new { @view.send(method) }
    end

    controller = @view.controller

    filters = if controller.respond_to?(:liquid_filters, true)
                controller.send(:liquid_filters)
              elsif controller.respond_to?(:master_helper_module)
                [controller.master_helper_module]
              else
                [controller._helpers]
              end


    @view.view_flow.content.each do |key, content|
      assigns["content_for_#{key.to_s}"] = content
    end

    partials_path = Liquid::LocalFileSystem.new(Refinery::Themes::Theme.theme_path.join("views/partials"))

    assigns['page'].parts.each do |part|
      Liquid::Template.parse(part.body).render(assigns)
      assigns["content_for_#{part.title}"] =
          Liquid::Template.parse(part.body).render(
              assigns,
              :filters => filters,
              :registers => {
                  :file_system => partials_path,
                  :action_view => @view,
                  :controller => @view.controller
              }).html_safe
    end if assigns['page']


    liquid = Liquid::Template.parse(CGI::unescape(template))
    liquid.render(assigns, :filters => filters, :registers => {:file_system => partials_path, :action_view => @view,
                                                               :controller => @view.controller})
  end

  def compilable?
    false
  end
end

