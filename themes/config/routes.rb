Rails.application.routes.prepend  do
  match "/themes/:key/image.png", :to => "refinery/themes/theme#sreenshot"
  match "/themes/assets/:mime_type/*file_path", :to => "refinery/themes/theme#asset", :via => :get
end

Refinery::Core::Engine.routes.prepend do
  # Admin routes
  namespace :themes, :path => '' do
    namespace :admin, :path => 'refinery' do
      scope :path => 'themes' do
        root :to => "themes#index", :via => :get

        resource :editor, :controller => 'editor' do
          root :to => "editor#index", :via => :get

          collection do
            post :list
            post :file
            post :save_file
            post :add
            post :rename
            post :delete
            post :upload
            get  :upload_file
          end
        end

      end


      resources :themes, :except => [:show, :destroy, :new] do
        collection do
          get :upload
          get :reset
          get :settings
          get :select_theme
        end
      end

    end
  end

end
