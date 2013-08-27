Spree::CheckoutHelper.module_eval do
  def checkout_progress_json()
    states = checkout_states
    crumbs = states.map do |state|
      text = t("order_state.#{state}").titleize
      current_index = states.index(@order.state)
      state_index = states.index(state)

      { :label => text, :link => checkout_state_path(state), :state => (state_index <= current_index ? 'enabled ' : 'disabled ')+(state == @order.state ? 'active' : '') }
    end

    return { :progress => crumbs }.to_json
  end
end