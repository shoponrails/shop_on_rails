class Refinery::Inquiries::InquiryDrop < Clot::BaseDrop
  self.liquid_attributes = [:created_at, :updated_at, :id, :name, :email, :phone, :message, :spam]
end
