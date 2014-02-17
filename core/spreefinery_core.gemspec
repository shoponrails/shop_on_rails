# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "spreefinery_core"
  gem.version       = "0.0.1RC1"
  gem.authors       = ["Alexander Negoda"]
  gem.email         = ["alexander.negoda@gmail.com"]
  gem.description   = "Spree + Refinerycms integration"
  gem.summary       = "Common functionality for Spree + Refinerycms integration"
  gem.homepage      = "https://github.com/shoponrails/spreefinery_core"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ["lib"]
  gem.required_ruby_version = '>= 2.0.0'

  gem.add_dependency 'spree'
  gem.add_dependency 'spree_i18n'

  gem.add_dependency 'refinerycms'
  #gem.add_dependency 'refinerycms-settings'
  gem.add_development_dependency 'colorize'
  gem.add_development_dependency 'machinist'

end
