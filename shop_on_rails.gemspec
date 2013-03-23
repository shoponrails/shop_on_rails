# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "shop_on_rails"
  s.version = "0.0.1"

  s.authors = ["Zee Yang, Alexander Negoda"]
  s.date = "2013-02-09"
  s.description = " ShopOnRails.com "
  s.email = "zee.yang@gmail.com, alexander.negoda@gmail.com"
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
  s.summary = "ShopOnRails.com"
  s.required_ruby_version = '>= 1.9.3'
  s.bindir        = 'bin'
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_dependency(%q<spreefinery_core>, [">= 0"])
  s.add_dependency(%q<spreefinery_themes>, [">= 0"])
  #s.add_dependency(%q<spreefinery_single_page_checkout>, [">= 0"])
  s.add_dependency(%q<refinerycms-blog>, [">= 0"])
  s.add_dependency(%q<refinerycms-inquiries>, [">= 0"])

  s.add_development_dependency(%q<jeweler>, [">= 1.8.3"])
  s.add_development_dependency(%q<simplecov>, [">= 0"])

  # Temporary hack until https://github.com/wycats/thor/issues/234 is fixed
  s.add_dependency 'thor', '>= 0.14.6'
end

