require 'fileutils'

version = ARGV.pop

%w( core themes ).each do |framework|
  puts "Installing #{framework}..."

  Dir.chdir(framework) do
    `gem build spreefinery_#{framework}.gemspec`
    `gem install spreefinery_#{framework}-#{version}.gem --no-ri --no-rdoc`
    FileUtils.remove "spreefinery_#{framework}-#{version}.gem"
  end

end

puts "Installing ShopOnRails..."
`gem build shop_on_rails.gemspec`
`gem install shop_on_rails-#{version}.gem --no-ri --no-rdoc `

FileUtils.remove "shop_on_rails-#{version}.gem"