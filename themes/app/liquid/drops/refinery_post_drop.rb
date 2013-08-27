class Refinery::Blog::PostDrop < Clot::BaseDrop

  self.liquid_attributes = [:id, :created_at, :updated_at, :draft, :author,
                            :custom_url, :custom_teaser, :source_url, :source_url_title, :access_count, :slug,
                            :comments, :tags]

  def body
    return if @source.body.nil?
    liquid = Liquid::Template.parse @source.body.html_safe
    liquid.render(@context.environments[0])
  end

  def title
    @source.title
  end

  def live
    @source.live?
  end

  def tag_list
     @source.tag_list
  end

  def base_tags
    @source.base_tags
  end

  def approved_comments_count
    @source.comments.approved.count
  end

  def approved_comments
    @source.comments.approved
  end

  def published_at
    @source.published_at.to_date
  end

  def categories
    @source.categories
  end

end
