require File.dirname(__FILE__) + '/../spec_helper'

describe "some shit that needs doin'" do

  describe "/:provider/:username" do
    it "should display all the pages that have been tipped"
    it "should show the profile image of the author"

    describe "unclaimed tips" do
      it "should ask them to sign up if they are that author"
      it "should have a way for the author to claim their tips"
      it "after initially claiming pages should take them to settings"
      it "should be able to provide bank and routing numbers"
      it "should pay authors to claim pages"
      it "should email authors when we put money into their accounts"
      it "should let authors accept payments via paypal"
      it "should show the profile image for the wanted author"
    end
    describe "an author who hasn't been tipped" do
      it "should say that this author hasn't recieved any tips"
      it "should make a pitch for why they should use copper"
      it "should try and grab their prifile image anywayt"
    end

    describe "authors that have signed up" do
      it "should communicate that we are paying them for their tips"
      it "should show all the tips they've recieved"
      it "should show the total amount they have earned in tips"
    end
  end

  describe "an admin" do
    it "should message twitter authors manually"
    it "should see admin info for /pages/:id"
  end

  describe "/pages/:id" do
    it "should be able to dismiss the big ass nav"
    it "should show how much revenue the page has earned"
    it "should have a link to the /:provider/:username"
    it "should be able to show soundcloud pages that have been tipped"
    it "should be able to show youtube pages that have been tipped"
    it "should be able to show vimeo pages that have been tipped"
    it "should be able to show facebook pages that have been tipped"
    it "should be able to show github pages that have been tipped"
    it "should be able to show tumblr pages that have been tipped"
    it "should be able to show flickr pages that have been tipped"
  end

  describe "the service" do
    it "should message twitter authors via @mentions"
    it "should message facebook authors directly"
    it "should message youtube authors directly"
    it "should message vimeo authors directly"
    it "should message github authors directly"
  end
end