class Spree::PaymentMethodDrop < Clot::BaseDrop

  self.liquid_attributes = [:id]

  def id
    @source.id
  end

  def name
    @source.name
  end

  def method_type
    @source.method_type
  end

  def active
    @source.active?
  end

  def verification_value
    @source.verification_value
  end

end