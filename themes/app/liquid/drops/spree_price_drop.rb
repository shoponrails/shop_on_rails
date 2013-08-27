class Spree::PriceDrop < Clot::BaseDrop

  self.liquid_attributes = [:id]

  def display_price
    @source.display_price
  end

  def money
    @source.money
  end

  def price
    @source.price
  end

  def amount
    @source.amount
  end

  def variant
    @source.variant
  end

end