class Spree::CreditCardDrop < Clot::BaseDrop

  self.liquid_attributes = [:id]

  def id
    @source.id
  end

  def cc_type
    @source.cc_type
  end

  def last_digits
    @source.last_digits
  end

  def first_name
    @source.first_name
  end

  def last_name
    @source.last_name
  end

  def month
    @source.month
  end

  def year
    @source.year
  end

  def number
    @source.number
  end

  def verification_value
    @source.verification_value
  end

end