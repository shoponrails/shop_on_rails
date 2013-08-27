module SpreeFilters

  include Clot::TagHelper

  def number_to_currency(number)
    @context.registers[:action_view].number_to_currency(number)
  end

end

Liquid::Template.register_filter SpreeFilters