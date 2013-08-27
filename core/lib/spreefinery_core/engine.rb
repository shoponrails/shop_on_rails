require "spree/authentication_helpers"

module SpreefineryCore
  class Engine < Rails::Engine
    require 'spree_core'
    require 'refinerycms-core'

    isolate_namespace SpreefineryCore::Engine
    engine_name "spreefinery_core"

    config.autoload_paths += %W(#{config.root}/lib)

    config.to_prepare do
      WillPaginate::ActiveRecord::RelationMethods.send :alias_method, :per, :per_page
      WillPaginate::ActiveRecord::RelationMethods.send :alias_method, :num_pages, :total_pages
      ApplicationController.send :include, Spree::AuthenticationHelpers
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
