class Spree::ProductDrop < Clot::BaseDrop

  self.liquid_attributes = [:id, :name, :description, :slug, :available_on, :shipping_category, :deleted_at, :meta_description, :meta_keywords]

  def master
    @source.master
  end

  def prices
    @source.prices
  end

  def variants
    @source.variants
  end

  def stock_items
    @source.stock_items
  end

  def tax_category
    @source.tax_category
  end

  def classifications
    @source.classifications
  end

  def available?
    @source.available?
  end

  def has_variants?
    @source.has_variants?
  end

  def price_with_currency
     @source.price_in(Spree::Config[:currency]).display_price
  end

  def variants_including_master
    @source.variants_including_master
  end

  def total_on_hand
    @source.total_on_hand
  end

  def option_types
    @source.option_types
  end

  def product_properties
    @source.product_properties
  end

  def properties
    @source.properties
  end

  def taxons
    @source.taxons
  end

  def images
    @source.images
  end

  def variant_images
    @source.variant_images
  end

  def product_image_url
    @source.images.first.attachment.url(:product)
  end

  def small_image_url
    @source.images.first.attachment.url(:small)
  end

  def large_image_url
    @source.images.first.attachment.url(:large)
  end

  def original_image_url
    @source.images.first.attachment.url(:original)
  end
end