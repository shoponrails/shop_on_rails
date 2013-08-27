class Spree::AdjustmentDrop < Clot::BaseDrop

  self.liquid_attributes = [:id, :label, :amount]

  def originator_type
    @source.originator_type
  end

  def display_amount
    @source.display_amount
  end
end