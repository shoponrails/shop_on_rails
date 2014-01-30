module Refinery
  module Themes
    class ThemeController < ::ApplicationController

      def screenshot
        send_data IO.read(File.join(Refinery::Themes::Theme.theme_path(params[:key]), "config/image.png")),
                  :disposition => "inline", :stream => false
      end

      def asset
        file_path = File.join(Refinery::Themes::Theme.theme_path, "assets", params[:mime_type], "#{params[:file_path]}.#{params[:format]}")

        if File.exists? file_path
          #file_type = Mime::Type.lookup_by_extension(File.extname(file_path)[1..-1])
          send_file file_path,  :disposition => "inline", :stream => false
        else
          render :text => "Not Found", :status => 404
        end
      end
    end
  end
end