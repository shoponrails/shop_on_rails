#coding: utf-8
namespace :shop_on_rails do
  desc 'Fresh setup with the Spree samples'
  task :setup_with_samples => :environment do
    puts "Removing a public/spree folder..."
    `rm -rf #{Rails.root}/public/spree`
    `cd #{Rails.root} && bundle exec rake shop_on_rails:setup --trace`
    `cd #{Rails.root} && bundle exec rake spree_sample:load --trace`
  end

  desc 'Refresh db without the Spree samples'
  task :refresh_db => :environment do
    puts "Drops any tables in db..."
    ActiveRecord::Base.connection.tables.each do |x|
      ActiveRecord::Base.connection.drop_table x
    end

    puts "Invoking: bundle exec rake db:migrate --trace ..."
    `cd #{Rails.root} && bundle exec rake db:migrate --trace`
    puts "Invoking:  bundle exec rake db:seed --trace ..."
    `cd #{Rails.root} && bundle exec rake db:seed --trace`

    puts "Invoking: SpreefineryCore::Engine.load_seed ..."
    SpreefineryCore::Engine.load_seed
  end

  desc 'Refresh db with the Spree samples'
  task :refresh_db_with_samples => :environment do
    puts "Removing a public/spree folder..."
    `rm -rf #{Rails.root}/public/spree`
    puts "Invoking bundle exec rake shop_on_rails:refresh_db --trace ..."
    `cd #{Rails.root} && bundle exec rake shop_on_rails:refresh_db --trace`
    puts "Invoking: bundle exec rake spree_sample:load --trace..."
    `cd #{Rails.root} && bundle exec rake spree_sample:load --trace`
  end


  desc 'Setup The ShopOnRails'
  task :setup => :environment do
    puts "Creating a themes folder..."
    `cd #{Rails.root} &&  mkdir themes`
     puts "Checkout a default theme..."
    `cd #{Rails.root}/themes && git clone git://github.com/shoponrails/spreefinery_default_theme.git default`
    puts "Checkout a spockets theme..."
    `cd #{Rails.root}/themes && git clone git://github.com/shoponrails/spreefinery_default_theme.git sprockets`
    `cd #{Rails.root}/themes/sprockets && git checkout -b sprockets origin/sprockets`

    puts "Invoking: bundle exec rails g spree:install --migrate=false --sample=false --seed=false --user_class=Refinery::User ..."
    `cd #{Rails.root} && bundle exec rails g spree:install --migrate=false --sample=false --seed=false --user_class=Refinery::User`
    puts "Invoking: bundle exec rails g refinery:cms --fresh-installation ..."
    `cd #{Rails.root} && bundle exec rails g refinery:cms --fresh-installation`
    puts "Invoking: bundle exec rails g refinery:i18n ..."
    `cd #{Rails.root} && bundle exec rails g refinery:i18n`
    puts "Invoking: bundle exec rails g refinery:pages ..."
    `cd #{Rails.root} && bundle exec rails g refinery:pages`
    puts "Invoking: bundle exec rails g refinery:inquiries ..."
    `cd #{Rails.root} && bundle exec rails g refinery:inquiries`
    puts "Invoking: bundle exec rails g refinery:blog ..."
    `cd #{Rails.root} && bundle exec rails g refinery:blog`
    puts "Invoking: bundle exec rails g refinery:news ..."
    `cd #{Rails.root} && bundle exec rails g refinery:news`
    puts "Invoking: bundle exec rake spreefinery_core:install:migrations ..."
    `cd #{Rails.root} && bundle exec rake spreefinery_core:install:migrations`
    puts "Invoking: bundle exec rake shop_on_rails:refresh_db ..."
    `cd #{Rails.root} && bundle exec rake shop_on_rails:refresh_db`
  end
end
