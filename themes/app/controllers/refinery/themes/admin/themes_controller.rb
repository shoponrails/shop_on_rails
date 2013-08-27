require 'sprockets'

module Refinery
  module Themes
    module Admin
      class ThemesController < ::Refinery::AdminController

        def index
          @themes = Refinery::Themes::Theme.all
        end

        def upload; end

        def settings; end

        def update

        end

        def reset
          FileUtils.rm_rf(Rails.root.join('themes', 'default')) if File.exist?(Rails.root.join('themes', 'default'))
          FileManager.unzip_file(File.join(SpreefineryThemes::Engine.root, "theme_template", "default.zip"))
          redirect_to themes_admin_root_url, :notice =>"The default theme successfully reset!"
        end

        def select_theme
          return unless params[:key]

          FileUtils.rm_rf(Rails.root.join('public', 'themes')) if File.exist?(Rails.root.join('public', 'themes'))
          ::Refinery::Setting.set(:current_theme, params[:key])

          Rails.application.config.assets.prepend Refinery::Themes::Theme.theme_path.join("assets/fonts").to_s
          Rails.application.config.assets.prepend Refinery::Themes::Theme.theme_path.join("assets/javascripts").to_s
          Rails.application.config.assets.prepend Refinery::Themes::Theme.theme_path.join("assets/stylesheets").to_s
          Rails.application.config.assets.prepend Refinery::Themes::Theme.theme_path.join("assets/images").to_s
          #Rake::Task['assets:precompile'].invoke

          ::I18n.load_path += Dir[Refinery::Themes::Theme.theme_path.join('config', 'locales', '*.{rb,yml}').to_s]

          redirect_to themes_admin_root_url
        end

        def create
          zipf = params[:zip_file]

          directory = "/tmp/uploads"
          `rm -rf "#{directory}"`
          `mkdir "#{directory}"`

          path = File.join(directory, zipf.original_filename)
          File.open(path, "wb") { |f| f.write(zipf.read) }

          FileManager.unzip_file(path)
          `rm #{path}`

          redirect_to themes_admin_root_url, :notice =>"A new theme was successfully uploaded and installed!"
        end

      end
    end
  end
end
