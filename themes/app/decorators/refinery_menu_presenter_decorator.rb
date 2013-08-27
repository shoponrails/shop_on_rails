Refinery::Pages::MenuPresenter.class_eval do

  self.list_tag = :ul
  self.list_item_tag = :li
  self.selected_css = :active
  self.first_css = :first
  self.last_css = :last

  private

  def render_menu(items)
    render_menu_items(items, holder: true)
  end

  def render_menu_items(menu_items, options = {})
    if menu_items.present?
      inner = Proc.new {
        menu_items.each_with_index.inject(ActiveSupport::SafeBuffer.new) do |buffer, (item, index)|
          buffer << render_menu_item(item, index)
        end
      }

      if options.has_key?(:holder)
        content_tag(list_tag, {:id => 'bootstrap-menu', :class => 'nav navbar-nav'}, nil, true, &inner)
      else
        content_tag(list_tag, {:class => 'dropdown-menu'}, nil, true, &inner)
      end


    end
  end

  def render_menu_item(menu_item, index)
    if  menu_item.children.empty?
      link = link_to(menu_item.title, context.refinery.url_for(menu_item.url))
    else
      link = link_to("#{menu_item.title}<b class=\"caret\"></b>".html_safe, context.refinery.url_for(menu_item.url), {:class => 'dropdown-toggle', 'data-toggle' => "dropdown" })
    end

    inner = Proc.new{
      buffer = ActiveSupport::SafeBuffer.new
      buffer << link
      buffer << render_menu_items(menu_item_children(menu_item))
      buffer
    }
    if menu_item.children.empty?
      content_tag(list_item_tag, {:class => menu_item_css(menu_item, index)}, nil, true, &inner)
    else
      content_tag(list_item_tag, {:class => "#{menu_item_css(menu_item, index)} dropdown"}, nil, true, &inner)
    end

  end


end