# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "shop_on_rails"
  gem.version       = "0.0.1RC1"
  gem.authors       = ["Alexander Negoda"]
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

  gem.add_dependency "spreefinery_core"
  gem.add_dependency "spreefinery_themes"
  gem.add_dependency "refinerycms-blog"
  gem.add_dependency "refinerycms-inquiries"
  gem.add_development_dependency(%q<jeweler>)
  gem.add_development_dependency(%q<simplecov>)

  # Temporary hack until https://github.com/wycats/thor/issues/234 is fixed
  gem.add_dependency 'thor'

end

