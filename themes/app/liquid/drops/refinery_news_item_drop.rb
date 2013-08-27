class Refinery::News::ItemDrop < Clot::BaseDrop
  self.liquid_attributes = [:created_at, :updated_at, :id, :title, :body, :content, :slug, :source,
                            :publish_date, :expiration_date]

  def body
    return if !@source.body.nil?
    liquid = Liquid::Template.parse @source.body.html_safe
    liquid.render(@context.environments[0])
  end
end
