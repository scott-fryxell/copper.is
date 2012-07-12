require 'spec_helper'

describe Check do
  it "should pay an author for their tips"
  it "should run periodicly to pay authors"
  it "should only pay authors for tips that have been paid for"
  it "shouldn't pay the author twice"
  it "should email the author when the check is sent"
  it "should verify that the funds have left the building"
  it "should balance the account against the bank"
  it "should make sure we've got rounding errors covered"
end