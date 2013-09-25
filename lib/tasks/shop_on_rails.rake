#coding: utf-8
namespace :shop_on_rails do

  desc 'Refresh db without the Spree samples'
  task :refresh_db => :environment do
    puts "Drops any tables in db..."
    ActiveRecord::Base.connection.tables.each do |x|
      ActiveRecord::Base.connection.drop_table x
    end

    puts "Invoking: bundle exec rake db:migrate --trace"
    `cd #{Rails.root} && bundle exec rake db:migrate --trace`
    puts "Invoking:  bundle exec rake db:seed --trace ..."
    `cd #{Rails.root} && bundle exec rake db:seed --trace`

    puts "Invoking: SpreefineryCore::Engine.load_seed"
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
    `cd #{Rails.root} && bundle exec rake shop_on_rails:fake_db --trace`
  end


  desc 'Setup The ShopOnRails'
  task :setup => :environment do
    puts "Creating a themes folder..."
    `cd #{Rails.root} &&  mkdir themes`
     puts "Checkout a default theme..."
    `cd #{Rails.root}/themes && git clone git://github.com/shoponrails/spreefinery_default_theme.git default`

    puts "Invoking: bundle exec rails g spree:install --migrate=false --sample=false --seed=false --user_class=Refinery::User ..."
    `cd #{Rails.root} && bundle exec rails g spree:install --migrate=false --sample=false --seed=false --auto_accept --user_class=Refinery::User`
    puts "Invoking: bundle exec rails g refinery:cms --fresh-installation ..."
    `cd #{Rails.root} && bundle exec rails g refinery:cms --fresh-installation --skip_db --skip_migrations`
    puts "Invoking: bundle exec rails g refinery:i18n ..."
    `cd #{Rails.root} && bundle exec rails g refinery:i18n`
    puts "Invoking: bundle exec rails g spree_i18n:install"
     `cd #{Rails.root} && bundle exec rails g spree_i18n:install --auto_run_migrations=true`
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
    `cd #{Rails.root} && bundle exec rake shop_on_rails:refresh_db --trace`
  end

  desc 'Refresh db without the Spree samples'
  task :fake_db => :environment do
    puts 'Generate test data...'

    10.times.map {
      user = Refinery::User.create(:email => Faker::Internet.email, :username => Faker::Internet.user_name, :password => "password",
                                   :password_confirmation => "password")

      user.add_role(:refinery)
    }

    3.times.map{
      Refinery::Page.create(
          :parent_id => Refinery::Page.find_by_slug('about').id,
          :title => Faker::Lorem.sentence,
          :menu_title => Faker::Lorem.words(2).join(' ').capitalize,
          :deletable => true,
          :show_in_menu => true
          #:view_template => '',
          #:layout_template => ''
      )
    }

    Refinery::Page.create(
        :title => 'Products Page',
        :menu_title => "Products",
        :deletable => true,
        :link_url => '/products',
        :show_in_menu => true
    )


    Refinery::Page.all.each do |page|
      page.parts.clear
      page.update_attribute(:view_template, "homepage")
      page.update_attribute(:layout_template, "site")

      Refinery::Pages.default_parts.each_with_index.each_with_index do |part, index|
        ::Refinery::PagePart.create(title: part.first,
                                    body: "<h1>#{part.first.camelcase}</h1>#{Faker::Lorem.paragraphs(rand(5..7)).join}".html_safe,
                                    refinery_page_id: page.id,
                                    :position => index
        )
      end
    end

    herounit = <<-ERB
    <h1>Hello, world!</h1>
    <p>This is a template for a simple marketing or informational website. It includes a large callout called the
      hero unit and three supporting pieces of content. Use it as a starting point to create something more unique.</p>
    <p><a href="#" class="btn btn-primary btn-large">Learn more »</a></p>
    ERB

    frontpage = Refinery::Page.find_by_slug("home")
    frontpage.parts << ::Refinery::PagePart.create(title: "hero-unit", body: herounit.html_safe, refinery_page_id: frontpage.id)
    frontpage.save

    Refinery::Blog::Category.all.map { |c|
      c.posts.clear
      c.destroy
    }
    10.times.map {
      Refinery::Blog::Category.create(:title => Faker::Lorem.words(rand(2..4)).join(' '))
    }

    Refinery::Blog::Post.all.map { |c| c.destroy }

    30.times.map {
      Refinery::Blog::Post.create(
          :title => Faker::Lorem.sentence,
          :body => Faker::Lorem.paragraphs(rand(5..7)).join,
          :draft => false,
          :author => Refinery::User.first,
          :published_at => (Time.now - rand(1..40).day),
          :custom_teaser => Faker::Lorem.paragraphs(rand(2..3)).join,
          :category_ids => ::Refinery::Blog::Category.offset(rand(Refinery::Blog::Category.count)).map(&:id),
          :tag_list => Faker::Lorem.words(rand(4..6)).join(', ')
      )
    }

    100.times.map {
      user = ::Refinery::User.offset(rand(::Refinery::User.count)).first
      comment = ::Refinery::Blog::Comment.new(
          :name => user.username,
          :email => user.email,
          :message => Faker::Lorem.paragraphs(rand(2..4)).join
      )
      comment.save(:validate => false)
      comment.approve!
      Refinery::Blog::Post.offset(rand(Refinery::Blog::Post.count)).first.comments << comment
    }

    100.times.map{
      Refinery::News::Item.create(
          :title => Faker::Lorem.sentence,
          :content => Faker::Lorem.paragraphs(rand(5..7)).join,
          :publish_date => (Time.now - rand(1..20).day),
          :expiration_date => (Time.now + rand(10..20).day)
      )
    }


  end

end
