ActionView::Base.class_eval do
  include Refinery::MenuHelper
  include Spree::ProductsHelper
  include Spree::BaseHelper
end

ActionView::LookupContext::ViewPaths.module_eval do
  def view_paths=(paths)
    @view_paths = ActionView::PathSet.new(Array.wrap(paths))
    @view_paths.paths.unshift ActionView::OptimizedFileSystemResolver.new(Refinery::Themes::Theme.theme_path.join("views"))
  end
end