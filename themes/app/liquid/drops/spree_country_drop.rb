class Spree::CountryDrop < Clot::BaseDrop

  self.liquid_attributes = [:id, :name, :states]
  
end