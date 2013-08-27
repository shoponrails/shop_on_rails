class Spree::ProductPropertyDrop < Clot::BaseDrop

  self.liquid_attributes = [:id, :value, :product, :property, :property_name]

end