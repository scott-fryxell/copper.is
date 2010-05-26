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

describe "Tipping from the service's tip page" do
  it "should include a visually offset area into which page URLs can be pasted"
  it "should include a large box into which page URLs can be pasted"
  it "should include a list of recent tips made by that user"
  it "should encourage the user to tip if they haven't tipped in the last week"
  it "should thank users when a tip is successfully given"
  it "should tell fans how many tips they've made recently"
  it "should paginate the list of recent tips if it includes more than 20 items"

  describe "and the tip is a duplicate"
    it "should indicate the duplicate tip did not go through"
    it "should include a message encouraging the user to tip elsewhere"
  end
end

describe "The recent tip list area" do
  it "should include the title of the page"
  it "should include the URL for the page"
  it "should have the URL for the page smaller and lower contrast than the title"
  it "should include the human-readable time since the tip was given"
end

describe "A fan" do
  it "should be able to tip a page"
  it "should be thanked for each tip"
  it "should be logged in when tipping"
  it "should have a tip queued up while they go through the authentication process"
  it "should have funds availabile for the tip"
  it "should not have to worry about duplicate tips (same page in any 24 hour period)"
end
