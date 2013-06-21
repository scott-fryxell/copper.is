FactoryGirl.define do
  sequence 'uid' do |n|
    n.to_s
  end

  sequence 'username' do |n|
    "foobar#{n}"
  end

  sequence 'a_n_string' do |n|
    n.to_s
  end

  sequence 'twitter_url_with_path' do |n|
    "https://twitter.com/1#{n}"
  end

  factory :authors_facebook, class: 'Authors::Facebook' do
    provider 'facebook'
    username 'scott.fryxell'
    uid '580281278'
  end

  factory :authors_phony, class: 'Authors::Phony' do
    provider 'phony'
    username { FactoryGirl.generate(:username) }
    uid { FactoryGirl.generate(:uid) }
  end

  factory :authors_twitter, class: 'Authors::Twitter' do
    provider 'twitter'
    username 'copper_is'
    uid '123545'
  end

  factory :authors_google, class: 'Authors::Google' do
    provider 'google'
    uid
    username
  end

  factory :authors_vimeo, class: 'Authors::Vimeo' do
    provider 'vimeo'
    uid '1'
    username 'foo'
  end

  factory :authors_flickr, class: 'Authors::Flickr' do
    provider 'flickr'
    uid
    username
  end

  factory :authors_tumblr, class: 'Authors::Tumblr' do
    provider 'tumblr'
    uid
    username
  end

  factory :authors_github, class: 'Authors::Github' do
    provider 'github'
    uid
    username
  end

  factory :authors_soundcloud, class: 'Authors::Soundcloud' do
    provider 'soundcloud'
    uid '2'
    username 'bar'
  end

  factory :authors_youtube, class: 'Authors::Youtube' do
    provider 'youtube'
    uid
    username
  end

  factory :role do
    name "Fan"
  end

  factory :user do
    name 'Joe'
    accept_terms true
    tip_preference_in_cents 50
    authors [FactoryGirl.create(:authors_phony,identity_state: :known)]
    roles [Role.find_or_create_by_name('Fan')]
  end

  factory :admin, class:'User' do
    name 'admin joe'
    accept_terms true
    tip_preference_in_cents 50
    authors [FactoryGirl.create(:authors_phony,identity_state: :known)]
    roles [Role.find_or_create_by_name('Admin')]
  end


  factory :user_email, class:'User' do
    name 'Joe'
    email 'scott+test@copper.is'
    accept_terms true
    tip_preference_in_cents 50
    authors [FactoryGirl.create(:authors_phony,identity_state: :known)]
    roles [Role.find_or_create_by_name('Fan')]
  end


  factory :user_phony, class:'User' do
    name 'dude'
    accept_terms true
    tip_preference_in_cents 50
    authors [FactoryGirl.create(:authors_phony,identity_state: :known, username:'her')]
    roles [Role.find_or_create_by_name('Fan')]
  end

  factory :order_current, :class => 'Order' do
    association :user
    order_state 'current'
  end

  factory :order_unpaid, :class => 'Order' do
    association :user
    order_state 'unpaid'
  end

  factory :order_paid, :class => 'Order' do
    association :user
    order_state 'paid'
  end

  factory :order_denied, :class => 'Order' do
    association :user
    order_state 'denied'
  end

  factory :authored_page, :class => 'Page' do
    url { FactoryGirl.generate(:twitter_url_with_path) }
    author_state 'adopted'
    association :author, factory: :authors_google
  end

  factory :page do
    url { FactoryGirl.generate(:twitter_url_with_path) }
  end

  factory :tip do
    association :order, factory: :order_current
    association :page
    amount_in_cents 100
  end

  factory :check do
    association :user
  end

  factory :check_paid, :class => 'Check' do
    association :user
    check_state 'paid'
  end

  factory :check_cashed, :class => 'Check' do
    association :user
    check_state 'cashed'
  end
end
