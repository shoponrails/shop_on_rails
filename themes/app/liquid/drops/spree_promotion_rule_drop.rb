class Spree::PromotionRuleDrop < Clot::BaseDrop

  self.liquid_attributes = [:id, :name, :product_ids_string]

  def product
    @source.product
  end

  def promotion
    @source.promotion
  end

end