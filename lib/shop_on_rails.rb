require 'thor'
require 'thor/group'

case ARGV.first
  when 'version', '-v', '--version'
    puts Gem.loaded_specs['shop_on_rails'].version
  when 'install'
    ARGV.shift
    require 'shop_on_rails/installer'
    ShopOnRails::Installer.start
  else
    return 'exit!'
end
