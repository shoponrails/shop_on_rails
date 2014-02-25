Rails.application.routes.prepend  do
  get "/themes/:key/image.png", :to => "refinery/themes/theme#screenshot"
  get "/themes/assets/:mime_type/*file_path", :to => "refinery/themes/theme#asset"
end

Refinery::Core::Engine.routes.prepend do
  # Admin routes
  namespace :themes, :path => '' do
    namespace :admin, :path => 'refinery' do
      scope :path => 'themes' do

        resource :editor, :controller => 'editor' do

          member do
            get :index
          end

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
