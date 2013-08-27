require 'refinerycms-core'
require 'spree_core'
require 'editable'
require 'hash'
require 'clot_engine'

module SpreefineryThemes
  require 'spreefinery/engine'

  class << self
    attr_writer :root

    def root
      @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
    end

    def factory_paths
      @factory_paths ||= [ root.join('spec', 'factories').to_s ]
    end
  end
end
