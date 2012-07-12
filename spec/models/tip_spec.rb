require 'spec_helper'

describe Tip do
  it 'amount in cents is between one cent and twenty dollars'
  it 'should belong to an order'
  it 'can delete promissed tips'
  it 'can not delete paid tips'
  it 'can not delete taken tips'
  it 'taken tips should belong to a check'
  it 'paid tips should belong to an order that is paid'
  it 'paid tips do not belong to a check'
  it 'should belong to a fan'
  it 'should belong to an author when in the taken state'
  it 'should belong to a page'
  it 'should have an amount in cents'
  it 'should have a url'
end
