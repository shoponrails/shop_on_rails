class Spree::PromotionDrop < Clot::BaseDrop

  self.liquid_attributes = [:id, :name, :code, :path]

  def promotion_rules
    @source.promotion_rules
  end

  def promotion_actions
    @source.promotion_actions
  end

  def products
    @source.products
  end

  def adjusted_credits_count
    @source.adjusted_credits_count
  end

  def credits
    @source.credits
  end

  def credits_count
    @source.credits_count
  end


end