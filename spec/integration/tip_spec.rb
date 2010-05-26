require File.dirname(__FILE__) + '/../spec_helper'

describe "Tipping a page" do
  it "should check if an entry for a page already exists"
  it "should create a new entry for a page if one doesn't exist"
  it "should display some stats about the page when a tip has occurred" 
  it "should display the total amount of money the page has received"
  it "should display how much money the page has received in the last month"
  it "should display other sites the publisher owns"
  it "should display a link to view the publisher's info"
end

describe "A fan" do
  it "should be able to tip a page"
  it "should be thanked for each tip"
  it "should be logged in when tipping"
  it "should have a tip queued up while they go through the authentication process"
  it "should have funds availabile for the tip"
  it "should not have to worry about duplicate tips (same page in any 24 hour period)"
end 
