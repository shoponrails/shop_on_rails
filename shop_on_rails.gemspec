# encoding: UTF-8

version = File.read(File.expand_path('../VERSION',__FILE__)).strip

Gem::Specification.new do |gem|
  gem.name          = "shop_on_rails"
  gem.version       =  version
  gem.author       = ["Alexander Negoda"]
  gem.email         = ["alexander.negoda@gmail.com"]
  gem.description   = "ShopOnRails.org"
  gem.summary       = "The ShopOnRails E-Commerce Engine"
  gem.homepage      = "http://shoponrails.org"
  gem.bindir        = 'bin'
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ["lib"]
  gem.required_ruby_version = '>= 1.9.3'

  gem.add_dependency "spreefinery_core", version
  gem.add_dependency "spreefinery_themes", version

  gem.add_development_dependency(%q<jeweler>)
  gem.add_development_dependency(%q<simplecov>)

end

