require File.dirname(__FILE__) + '/../spec_helper'

describe "The standard Weave page" do
  it "should contain a logo" do
    visit "/"
    assert_have_selector "body img[item=logo]"
  end

  it "should contain a global nav section" do
    visit "/"
    assert_have_selector "body > header"
  end

  it "should contain an account section" do
    visit "/"
    assert_have_selector "body > aside"
  end
  it "should contain a courtesy nav section" do
    visit "/"
    assert_have_selector "body > footer"
  end
  it "should contain a content area" do
    visit "/"
    assert_have_selector "body > section"
  end

  describe "global navigation" do
    it "should link to the pages report" do
      visit "/"
      assert_have_selector "body > header > nav"
      click_link "Pages"
    end
    it "should link to the Sites report" do
      visit "/"
      assert_have_selector "body > header > nav"
      click_link "Sites"

    end
    it "should link to the blog"
    it "should link to the user's home page"
    it "should contain a contextual 'fun' widget" do
      visit "/"
      assert_have_selector "body > header > a > img"
    end

  end

  describe "account section" do
    describe "when logged in"do
      it "should link to a tip page for a fan"
      it "should link to a logout page when the fan is logged in"
      it "should link to a fan home page"
      it "should link to a publisher home page for a publisher"
      it "should link to a administrators home page for an administrator"
    end
    describe "when not logged in"do
      it "should include a login or register widget when guest is unknown"
    end
  end

  describe "courtesy navigation" do
    it "should link to an Terms & Conditions  page" do
      visit "/"
      assert_have_selector "body > footer > nav"
      click_link "Terms & Conditions"
    end
    it "should link to an Terms & Conditions  page" do
      visit "/"
      assert_have_selector "body > footer > nav"
      click_link "Privacy"
    end

    it "should link to a subscribe page" do
      visit "/"
      assert_have_selector "body > footer > nav"
      click_link "Subscribe"
    end
    it "should link to a contact page" do
      visit "/"
      assert_have_selector "body > footer > nav"
      click_link "Contact"
    end

    it "should contain the last 3 blog entries"
  end
end