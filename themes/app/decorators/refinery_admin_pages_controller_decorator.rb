Refinery::Admin::PagesController.class_eval do
  def load_valid_templates
    @valid_layout_templates = Refinery::Themes::Theme.layouts
    @valid_view_templates = Refinery::Themes::Theme.templates
  end
end