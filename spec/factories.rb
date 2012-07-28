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
    "http://twitter.com/#!/1#{n}"
  end

  factory :identities_facebook, class: 'Identities::Facebook' do
    provider 'facebook'
    username 'scott.fryxell'
    uid '580281278'
  end

  factory :identities_phony, class: 'Identities::Phony' do
    provider 'phony'
    username { FactoryGirl.generate(:username) }
    uid { FactoryGirl.generate(:username) }
  end

  factory :identities_twitter, class: 'Identities::Twitter' do
    provider 'twitter'
    username 'copper_is'
    uid '123545'
  end

  factory :identities_google, class: 'Identities::Google' do
    provider 'google'
    uid
    username
  end

  factory :identities_vimeo, class: 'Identities::Vimeo' do
    provider 'vimeo'
    uid '1'
    username 'foo'
  end

  factory :identities_flickr, class: 'Identities::Flickr' do
    provider 'flickr'
    uid
    username
  end

  factory :identities_tumblr, class: 'Identities::Tumblr' do
    provider 'tumblr'
    uid
    username
  end

  factory :identities_github, class: 'Identities::Github' do
    provider 'github'
    uid
    username
  end

  factory :identities_soundcloud, class: 'Identities::Soundcloud' do
    provider 'soundcloud'
    uid '2'
    username 'bar'
  end

  factory :identities_youtube, class: 'Identities::Youtube' do
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
    identities [FactoryGirl.create(:identities_phony,identity_state: :known)]
    roles [Role.find_or_create_by_name('Fan')]
  end

  factory :user_phony, class:'User' do
    name 'dude'
    accept_terms true
    tip_preference_in_cents 50
    identities [FactoryGirl.create(:identities_phony,identity_state: :known, username:'her')]
    roles [Role.find_or_create_by_name('Fan')]
  end

  factory :order_current, :class => 'Order' do
    association :user
    state 'current'
  end

  factory :order_unpaid, :class => 'Order' do
    association :user
    state 'unpaid'
  end

  factory :order_paid, :class => 'Order' do
    association :user
    state 'paid'
  end

  factory :order_denied, :class => 'Order' do
    association :user
    state 'denied'
  end

  factory :authored_page, :class => 'Page' do
    url { FactoryGirl.generate(:twitter_url_with_path) }
    author_state 'adopted'
    association :identity, factory: :identities_google
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
