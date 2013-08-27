class Spree::AddressDrop < Clot::BaseDrop

  self.liquid_attributes = [:id, :firstname, :lastname, :address1, :address2, :city, :country, :shipments,
                            :state, :zipcode, :phone, :alternative_phone]


  def empty
    @source.empty?
  end

end