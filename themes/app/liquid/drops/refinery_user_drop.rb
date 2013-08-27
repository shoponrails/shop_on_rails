class Refinery::UserDrop < Clot::BaseDrop

  #class_attribute :liquid_attributes
  self.liquid_attributes = [:email, :username]

  def orders
    @source.orders
  end

  def roles
    @source.roles
  end

  def ship_address
    @source.ship_address
  end

  def bill_address
    @source.bill_address
  end
  
end