class Spree::ImageDrop < Clot::BaseDrop

  self.liquid_attributes = [:attachment, :alt]

  def product_url
    @source.attachment.url(:product)
  end

  def small_url
    @source.attachment.url(:small)
  end

  def original_url
    @source.attachment.url(:original)
  end

  def mini_url
    @source.attachment.url(:mini)
  end

  def large_url
    @source.attachment.url(:large)
  end

end