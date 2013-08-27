class Spree::ProductDrop < Clot::BaseDrop

  self.liquid_attributes = [:id, :name, :price, :permalink, :available_on, :shipping_category, :deleted_at,
                            :meta_description, :meta_keywords, :product_option_types, :option_types, :product_properties,
                            :properties, :images, :taxons, :master, :variants,  :variants_including_master
  ]

  def description
    @source.description
  end

  def master
    @source.master
  end

  def variants
    @source.variants
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

  def product_option_types
    @source.product_option_types
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