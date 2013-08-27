class OptionValueDrop < Clot::BaseDrop
  self.liquid_attributes = [:name, :option_type, :position, :presentation, :variants]
end