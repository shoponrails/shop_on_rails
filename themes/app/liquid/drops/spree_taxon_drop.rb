class Spree::TaxonDrop < Clot::BaseDrop

  self.liquid_attributes = [:products, :taxonomy, :parent, :classifications]

  def name
    @source.name
  end

  def description
    @source.description
  end

  def siblings
    @source.siblings
  end

  def self_and_ancestors
    @source.self_and_ancestors
  end

  def ancestors
    @source.ancestors
  end

  def children
    @source.children
  end

  def permalink
    @source.permalink
  end

  def children_empty
    @source.children.empty?
  end

  def seo_title
    @source.seo_title
  end
end
