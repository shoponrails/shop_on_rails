class Spree::PropertyDrop < Clot::BaseDrop

  self.liquid_attributes = [:id, :name, :prototypes, :product_properties, :products, :presentation]

end