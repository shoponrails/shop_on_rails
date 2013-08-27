Spree::Order.class_eval do
  class << self
    def find_last_used_addresses(email)
      past = self.order("id desc").where(:email => email).where("state != 'cart'").limit(8)
      if order = past.detect(&:bill_address)
        bill_address = order.bill_address.clone if order.bill_address
        ship_address = order.ship_address.clone if order.ship_address
      end
      return bill_address , ship_address
    end
  end
end
