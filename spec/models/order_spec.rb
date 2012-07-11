require 'spec_helper'

describe Order do
  it "charge the fan's credit card through stripe"
  it "should send the fan a reciept"
  it "should retry declined card three times"
  it "should only charge a user when they've tipped over 15 dollars"
  it "should never charge twice for the same order"
  it "should not modify an order after it's been successfully paid"

end
