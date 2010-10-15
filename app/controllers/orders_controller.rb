class OrdersController < ApplicationController
  filter_access_to :all, :attribute_check => false

  def new
    new_helper
    @order.account = Account.new
    @order.account.billing_address = Address.new
  end

  def prepare
    assemble_order!

    if @order.valid?
      render :prepare
    else
      flash[:error] = @order.errors.full_messages + @billing_address.errors.full_messages
      new_helper
      render :new
    end
  end

  def create
    assemble_order!

    if params[:change] == "Change" # Go back to new and make edits
      new_helper
      render :new

    elsif params[:commit] == "Make Payment" # Place the order
      if @order.place_order
        flash[:notice] = "successful purchase"
        render :show
      else
        flash[:error] = @order.errors.full_messages + @billing_address.errors.full_messages
        new_helper
        render :new
      end
    end
  end

  private

  def new_helper
    @order = Order.new
    @fee_percent = Configuration.find_by_property(Configuration::FEE_PERCENT).value
    @card_types = CardType.find(:all, :order => :id).map {|c| [c.name.capitalize, c.id] }
    @states = State.find(:all, :order => :name).map {|s| [s.name.capitalize, s.abbreviation] }
    @countries = Country.find(:all, :order => :name).map {|c| [c.name, c.abbreviation] }
  end

  def assemble_order!
    @billing_address = Address.create(params[:billing_address])

    @account = Account.new(params[:account])
    @account.user = current_user
    @account.billing_address = @billing_address
    @account.save # TODO - find_or_creat.first.  Should be factored out when we clean up Account for production, creating too early and creating multiple instances of same account

    @order = Order.new(:amount_in_cents => params[:order][:amount_in_cents]) # TODO - wire in helper module method
    @order.ip_address = request.remote_ip
    @order.account = @account
  end

end