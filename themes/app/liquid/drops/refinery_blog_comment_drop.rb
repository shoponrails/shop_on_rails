class Refinery::Blog::CommentDrop < Clot::BaseDrop

  self.liquid_attributes = [:id, :updated_at, :email, :name]

  def message
    return if @source.message.nil?
    @source.message.html_safe
  end

  def created_at
    @source.created_at.to_date
  end

end
