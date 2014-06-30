require 'open-uri'

module Refinery
  module Themes
    class Theme < Refinery::Core::BaseModel

      def default_assigns(str)
        yaml = YAML::load(str)["assigns"] || false
        return {} unless yaml
        assigns = extract_assigns(yaml, :vars)
        extract_assigns(yaml, :collections).each do |k, v|
          assigns[k] = Collection.find_by_key v
        end
        return assigns
      end


      class << self
        include ActionController::DataStreaming

        attr_accessor :content_type, :headers

        def current_theme_key
          ::Refinery::Setting.find_or_set(:current_theme, "default") if ActiveRecord::Base.connection.table_exists? 'refinery_settings'
        end

        def current_theme_config
          config_for(current_theme_key)
        end

        def default_layout
          ::Refinery::Setting.find_or_set(:default_layout, "site") if ActiveRecord::Base.connection.table_exists? 'refinery_settings'
        end

        def theme_path(theme_dir=current_theme_key)
          Rails.root.join("themes/#{theme_dir}")
        end

        def layout_raw(file_name)
          File.read(theme_path.join("layouts/#{file_name}.*.liquid"))
        end

        def all
          Dir.glob(Rails.root.join("themes", "*")).collect { |dir|
            config_for(dir.split("/").last)
          }
        end

        def config_for(key)
          YAML::load(File.open(theme_path(key).join("config/config.yml")))
        end

        def layouts
          layouts_list(theme_path.join("views/layouts", "*.liquid"))
        end

        def templates
          templates_list(theme_path.join("views/refinery/pages/", "*.liquid"))
        end

        private

        def layouts_list(path)
          Dir.glob(path).collect { |file|
            file.split("/").last.gsub(/.liquid/, "")
          }
        end

        def templates_list(path)
          Dir.glob(path).collect { |file|
            file.split("/").last.gsub(/.liquid/, "")
          }
        end

      end
    end
  end
end
