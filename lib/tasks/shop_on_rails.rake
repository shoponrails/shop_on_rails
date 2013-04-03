#coding: utf-8
require 'colorize'

namespace :shop_on_rails do
  desc 'Fresh setup with the Spree samples'
  task :setup_with_samples => :environment do
    puts "Removing a public/spree folder...".green
    `rm -rf #{Rails.root}/public/spree`
    `cd #{Rails.root} && bundle exec rake shop_on_rails:setup --trace`
    `cd #{Rails.root} && bundle exec rake spree_sample:load --trace`
  end

  desc 'Refresh db without the Spree samples'
  task :refresh_db => :environment do
    puts "Drops any tables in db...".green
    ActiveRecord::Base.connection.tables.each do |x|
      ActiveRecord::Base.connection.drop_table x
    end

    puts "Invoking: bundle exec rake db:migrate --trace ...".green
    `cd #{Rails.root} && bundle exec rake db:migrate --trace`
    puts "Invoking:  bundle exec rake db:seed --trace ...".green
    `cd #{Rails.root} && bundle exec rake db:seed --trace`

    puts "Invoking: SpreefineryCore::Engine.load_seed ...".green
    SpreefineryCore::Engine.load_seed
  end

  desc 'Refresh db with the Spree samples'
  task :refresh_db_with_samples => :environment do
    puts "Removing a public/spree folder...".green
    `rm -rf #{Rails.root}/public/spree`
    puts "Invoking bundle exec rake shop_on_rails:refresh_db --trace ...".green
    `cd #{Rails.root} && bundle exec rake shop_on_rails:refresh_db --trace`
    puts "Invoking: bundle exec rake spree_sample:load --trace...".green
    `cd #{Rails.root} && bundle exec rake spree_sample:load --trace`
  end


  desc 'Setup The ShopOnRails'
  task :setup => :environment do
    puts "Creating a themes folder..." .green
    `cd #{Rails.root} &&  mkdir themes`
     puts "Checkout a default theme...".green
    `cd #{Rails.root}/themes && git clone git://github.com/shoponrails/spreefinery_default_theme.git default`
    puts "Checkout a spockets theme...".green
    `cd #{Rails.root}/themes && git clone git://github.com/shoponrails/spreefinery_default_theme.git sprockets`
    `cd #{Rails.root}/themes/sprockets && git checkout -b sprockets origin/sprockets`

    puts "Invoking: bundle exec rails g spree:install --migrate=false --sample=false --seed=false --user_class=Refinery::User ...".green
    `cd #{Rails.root} && bundle exec rails g spree:install --migrate=false --sample=false --seed=false --user_class=Refinery::User`
    puts "Invoking: bundle exec rails g refinery:cms --fresh-installation ...".green
    `cd #{Rails.root} && bundle exec rails g refinery:cms --fresh-installation`
    puts "Invoking: bundle exec rails g refinery:i18n ...".green
    `cd #{Rails.root} && bundle exec rails g refinery:i18n`
    puts "Invoking: bundle exec rails g refinery:pages ...".green
    `cd #{Rails.root} && bundle exec rails g refinery:pages`
    puts "Invoking: bundle exec rails g refinery:inquiries ...".green
    `cd #{Rails.root} && bundle exec rails g refinery:inquiries`
    puts "Invoking: bundle exec rails g refinery:blog ...".green
    `cd #{Rails.root} && bundle exec rails g refinery:blog`
    puts "Invoking: bundle exec rails g refinery:news ...".green
    `cd #{Rails.root} && bundle exec rails g refinery:news`
    puts "Invoking: bundle exec rake spreefinery_core:install:migrations ...".green
    `cd #{Rails.root} && bundle exec rake spreefinery_core:install:migrations`
    puts "Invoking: bundle exec rake shop_on_rails:refresh_db ...".green
    `cd #{Rails.root} && bundle exec rake shop_on_rails:refresh_db`
  end
end
