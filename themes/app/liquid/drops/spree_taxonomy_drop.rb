class Spree::TaxonomyDrop < Clot::BaseDrop
  self.liquid_attributes = [:name, :taxons, :root]
end