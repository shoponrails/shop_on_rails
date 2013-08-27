require 'acts-as-taggable-on'

class ::ActsAsTaggableOn::TagDrop < Clot::BaseDrop
  self.liquid_attributes = [:id, :name]

  def id
    @source.id
  end

  def name
    @source.name
  end

  def name_parameterize
    @source.name.parameterize
  end
  
end