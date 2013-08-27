class Spree::OrderDrop < Clot::BaseDrop

  self.liquid_attributes = [:id, :line_items,  :user, :number, :email, :total, :item_total, :ship_total,
                            :adjustment_total, :state, :tax_total, :special_instructions]

  def token
    @source.token
  end

  def display_total
    @source.display_total
  end

  def display_item_total
    @source.display_item_total
  end

  def bill_address
    @source.bill_address
  end

  def ship_address
    @source.ship_address
  end

  def billing_firstname
    @source.billing_firstname
  end

  def billing_lastname
    @source.billing_lastname
  end

  def rate_hash
   @source.rate_hash.inject([]) do |result, rate|
      hash = {}
      hash['shipping_method'] = rate.shipping_method
      hash['name'] = rate.name
      hash['cost'] = rate.cost
      hash['currency'] = rate.currency
      hash['id'] = rate.id
      hash['display_price'] = rate.display_price
      result << hash
   end
  end

  def available_payment_methods
    @source.available_payment_methods
  end

  def credit_cards
    @source.credit_cards
  end

  def completed
    @source.completed?
  end

  def to_param
    @source.number.to_s.to_url.upcase
  end

  def adjustments
    @source.adjustments.eligible
  end

  def shipping_method
    @source.shipping_method
  end

  def same_as_bill_address
    @source.ship_address.same_as?(@source.bill_address)
  end

  def same_as_ship_address
    @source.bill_address.same_as?(@source.ship_address)
  end


end