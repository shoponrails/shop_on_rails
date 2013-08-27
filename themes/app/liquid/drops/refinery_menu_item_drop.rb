class Refinery::MenuItemDrop < Clot::BaseDrop

  self.liquid_attributes = [:title, :parent, :depth, :menu, :menu_match]

  def url
    @context.registers[:action_view].url_for(@source.url)
  end

  def children
    @source.children
  end

  def ancestors
    @source.ancestors
  end

end