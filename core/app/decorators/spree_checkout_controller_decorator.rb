Spree::CheckoutController.class_eval do
  respond_to :html, :json

  before_filter :check_registration, :except => [:sign_up, :registration, :update_registration]


  def registration
    @user ||= Refinery::User.new
    session[:user_return_to] = checkout_path
  end

  def update_registration
    fire_event("spree.user.signup", :order => current_order)
    # hack - temporarily change the state to something other than cart so we can validate the order email address
    current_order.state = 'address'
    if current_order.update_attributes(params[:order])
      redirect_to checkout_path
    else
      @user = Refinery::User.new
      render 'registration'
    end
  end

  def sign_up
    @user = build_resource(params[:user])
    @order = current_order
    if @user.save
      set_flash_message(:notice, :signed_up)
      sign_in(:user, @user)
      session[:spree_user_signup] = true
      associate_user
      fire_event('spree.checkout.update')

      if @order.next
        redirect_to checkout_path
      else
        flash[:error] = t(:payment_processing_failed)
        respond_with(@order, :location => checkout_state_path(@order.state))
        return
      end
    else
      render :registration
    end
  end


  private

  def before_address
    if params[:bill_address] and params[:bill_address].eql?('bill_address_existing')
      params[:order].delete(:bill_address_attributes)
    end

    if params[:ship_address] and params[:ship_address].eql?('ship_address_existing')
      params[:order].delete(:ship_address_attributes)
    end


    return if @order.bill_address or @order.ship_address
    last_used_bill_address, last_used_ship_address = Spree::Order.find_last_used_addresses(@order.email)
    preferred_bill_address, preferred_ship_address = spree_current_user.bill_address, spree_current_user.ship_address if spree_current_user.respond_to?(:bill_address) && spree_current_user.respond_to?(:ship_address)
    @order.bill_address ||= preferred_bill_address || last_used_bill_address || Spree::Address.default
    @order.ship_address ||= preferred_ship_address || last_used_ship_address || Spree::Address.default

  end


  def skip_state_validation?
    %w(sign_up registration update_registration).include?(params[:action])
  end

  # Introduces a registration step whenever the +registration_step+ preference is true.
  def check_registration
    return unless ::Refinery::Setting.find_or_set(:registration_step, true)
    return if spree_current_user or current_order.email
    redirect_to spree.checkout_registration_path
  end

  # Overrides the equivalent method defined in Spree::Core.  This variation of the method will ensure that users
  # are redirected to the tokenized order url unless authenticated as a registered user.
  def completion_route
    return order_path(@order) if spree_current_user
    spree.token_order_path(@order, @order.token)
  end

  protected

  def resource_name
    :user
  end

  def resource
    @resource ||= Refinery::User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def build_resource(hash=nil)
    hash ||= params[resource_name] || {}
    instance_variable_set(:"@#{resource_name}", Refinery::User.new_with_session(hash, session))
  end

  def set_flash_message(key, kind, options={})
    options[:scope] = "devise.#{controller_name}"
    options[:default] = Array(options[:default]).unshift(kind.to_sym)
    options[:resource_name] = resource_name
    options = devise_i18n_options(options) if respond_to?(:devise_i18n_options, true)
    message = I18n.t("#{resource_name}.#{kind}", options)
    flash[key] = message if message.present?
  end


end