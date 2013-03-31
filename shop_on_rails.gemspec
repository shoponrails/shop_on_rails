# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "shop_on_rails"
  s.version = "0.0.1"

  s.authors = ["Alexander Negoda"]
  s.date = "2013-02-09"
  s.description = " ShopOnRails.org "
  s.email = "alexander.negoda@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = `git ls-files`.split($/)
  s.homepage = "https://github.com/shoponrails/shop_on_rails"
  s.rubyforge_project = "shop_on_rails"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "ShopOnRails.org"
  s.required_ruby_version = '>= 1.9.3'
  s.bindir        = 'bin'
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  #s.add_dependency 'spreefinery_core'
  #s.add_dependency 'spreefinery_themes'
  #s.add_dependency 'refinerycms-blog', '>= 2.0.9'
  #s.add_dependency 'refinerycms-inquiries', '>= 2.0.9'

  s.add_development_dependency 'gemcutter'
  s.add_development_dependency(%q<jeweler>, [">= 1.8.3"])
  s.add_development_dependency(%q<simplecov>, [">= 0"])

  # Temporary hack until https://github.com/wycats/thor/issues/234 is fixed
  s.add_dependency 'thor', '>= 0.14.6'
end

