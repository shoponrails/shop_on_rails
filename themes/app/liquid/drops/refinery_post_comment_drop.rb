class Refinery::Blog::CommentDrop < Clot::BaseDrop

  self.liquid_attributes = [:post, :spam, :name, :email, :message]

  def message
    return if @source.message.nil?
    @source.message.html_safe
  end
end