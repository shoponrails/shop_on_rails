Refinery::User.class_eval do

  has_many :orders, :class_name => 'Spree::Order'
  belongs_to :ship_address, :foreign_key => 'ship_address_id', :class_name => 'Spree::Address'
  belongs_to :bill_address, :foreign_key => 'bill_address_id', :class_name => 'Spree::Address'

  before_destroy :check_completed_orders

  users_table_name = Refinery::User.table_name
  scope :registered, where("#{users_table_name}.email NOT LIKE ?", "%@example.net")

  def self.anonymous!
    token = Refinery::User.generate_token(:persistence_token)
    User.create(:email => "#{token}@example.net", :password => token, :password_confirmation => token, :persistence_token => token)
  end

  def anonymous?
    email =~ /@example.net$/ ? true : false
  end

  def generate_spree_api_key!
    self.spree_api_key = SecureRandom.hex(24)
    save!
  end

  def clear_spree_api_key!
    self.spree_api_key = nil
    save!
  end

  private

  def check_completed_orders
    raise DestroyWithOrdersError if orders.complete.present?
  end

  # Generate a friendly string randomically to be used as token.
  def self.friendly_token
    SecureRandom.base64(15).tr('+/=', '-_ ').strip.delete("\n")
  end

  # Generate a token by looping and ensuring does not already exist.
  def self.generate_token(column)
    loop do
      token = friendly_token
      break token unless find(:first, :conditions => { column => token })
    end
  end
end