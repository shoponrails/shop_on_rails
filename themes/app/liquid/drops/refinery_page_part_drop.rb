class Refinery::PagePartDrop < Clot::BaseDrop

  self.liquid_attributes = [:created_at, :updated_at, :id, :page, :position]

  def page_id
    @page_id ||= @source.refinery_page_id
  end

  def key
    @key ||= @source.title.underscore.split.join("_")
  end

  def body
    return if !@source.body.nil?
    liquid = Liquid::Template.parse @source.body.html_safe
    liquid.render(@context.environments[0])
  end

end