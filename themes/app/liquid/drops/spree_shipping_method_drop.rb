class Spree::ShippingMethodDrop < Clot::BaseDrop

  self.liquid_attributes = [:id]

  def id
    @source.id
  end

  def name
    @source.name
  end

  def zone
    @source.zone
  end

  def shipping_category
    @source.shipping_category
  end

end