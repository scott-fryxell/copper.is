require 'spec_helper'

describe "scratch_pad'", :slow,  :type => :feature do

  describe "/:provider/:username" do
    it " display all the pages that have been tipped"
    it " show the profile image of the author"

    describe "unclaimed tips" do
      it " ask them to sign up if they are that author"
      it " have a way for the author to claim their tips"
      it "after initially claiming pages  take them to settings"
      it " be able to provide bank and routing numbers"
      it " pay authors to claim pages"
      it " email authors when we put money into their accounts"
      it " let authors accept payments via paypal"
      it " show the profile image for the wanted author"
    end
    describe "an author who hasn't been tipped" do
      it " say that this author hasn't recieved any tips"
      it " make a pitch for why they  use copper"
      it " try and grab their prifile image anywayt"
    end

    describe "authors that have signed up" do
      it " communicate that we are paying them for their tips"
      it " show all the tips they've recieved"
      it " show the total amount they have earned in tips"
    end
  end

  describe "an admin" do
    it " message twitter authors manually"
    it " see admin info for /pages/:id"
  end

  describe "/pages/:id" do
    it " be able to dismiss the big ass nav"
    it " show how much revenue the page has earned"
    it " have a link to the /:provider/:username"
    it " be able to show soundcloud pages that have been tipped"
    it " be able to show youtube pages that have been tipped"
    it " be able to show vimeo pages that have been tipped"
    it " be able to show facebook pages that have been tipped"
    it " be able to show github pages that have been tipped"
    it " be able to show tumblr pages that have been tipped"
    it " be able to show flickr pages that have been tipped"
  end

  describe "the service" do
    it " message twitter authors via @mentions"
    it " message facebook authors directly"
    it " message youtube authors directly"
    it " message vimeo authors directly"
    it " message github authors directly"
  end
end
