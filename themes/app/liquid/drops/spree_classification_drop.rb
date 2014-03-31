class Spree::ClassificationDrop < Clot::BaseDrop
  self.liquid_attributes = [:product, :taxon]
end