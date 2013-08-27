class Refinery::Blog::CategoryDrop < Clot::BaseDrop

  self.liquid_attributes = [:created_at, :updated_at, :id, :title, :slug, :posts, :post_count]

end
