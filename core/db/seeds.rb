#coding: utf-8

def random_str
  (0...8).map { 65.+(rand(25)).chr }.join
end

puts "Creating an admin user..."

Refinery::User.all.map { |c| c.destroy }

admin = Refinery::User.create(:email => "admin@example.com", :username => "admin", :password => "password",
                              :password_confirmation => "password")

admin.add_role(:refinery)
admin.add_role(:superuser)
admin.plugins = Refinery::Plugins.registered.in_menu.names

puts "Run: Refinery::User.first.spree_roles << Spree::Role.find_or_create_by_name('admin') ..."
Refinery::User.first.spree_roles << Spree::Role.find_or_create_by_name("admin")
