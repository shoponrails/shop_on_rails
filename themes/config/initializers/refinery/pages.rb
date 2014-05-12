# encoding: utf-8
Refinery::Pages.configure do |config|
  config.default_parts = ["left_sidebar", "body", "right_sidebar"]
  config.new_page_parts = true
  config.use_layout_templates = true
  config.use_custom_slugs = true
end

