FactoryGirl.define do
  sequence 'uid' do |n|
    n.to_s
  end
  
  sequence 'username' do |n|
    "foobar#{n}"
  end
  
  sequence 'twitter_url_with_path' do |n|
    "http://twitter.com/#!/1#{n}"
  end

  factory :identities_facebook, class: 'Identities::Facebook' do
    provider 'facebook'
    uid { FactoryGirl.generate('uid') }
  end
  
  factory :identities_twitter, class: 'Identities::Twitter' do
    provider 'twitter'
    username { FactoryGirl.generate('username') }
    uid { FactoryGirl.generate('uid') }
  end
                                      
  # factory :identities_twitter_ugly, class: 'Identities::Twitter' do
  #   provider 'twitter'
  #   username '_ugly'
  #   uid '26368397'
  # end

  factory :identities_google, class: 'Identities::Google' do
    provider 'google'
    uid { FactoryGirl.generate(:uid) }
    username { FactoryGirl.generate('username') }
  end

  factory :identities_vimeo, class: 'Identities::Vimeo' do
    provider 'vimeo'
    uid { FactoryGirl.generate(:uid) }
    username { FactoryGirl.generate('username') }
  end

  factory :identities_flickr, class: 'Identities::Flickr' do
    provider 'flickr'
    uid { FactoryGirl.generate(:uid) }
    username { FactoryGirl.generate('username') }
  end

  factory :identities_tumblr, class: 'Identities::Tumblr' do
    provider 'tumblr'
    uid { FactoryGirl.generate(:uid) }
    username { FactoryGirl.generate('username') }
  end

  factory :identities_github, class: 'Identities::Github' do
    provider 'github'
    uid { FactoryGirl.generate(:uid) }
    username { FactoryGirl.generate('username') }
  end

  factory :identities_soundcloud, class: 'Identities::Soundcloud' do
    provider 'soundcloud'
    uid { FactoryGirl.generate(:uid) }
    username { FactoryGirl.generate('username') }
  end

  factory :identities_youtube, class: 'Identities::Youtube' do
    provider 'youtube'
    uid { FactoryGirl.generate(:uid) }
    username { FactoryGirl.generate('username') }
  end

  factory :role do
    name "Patron"
  end

  # factory :unaccepted_user, :class => 'User' do
  # end

  factory :user do
    name 'Joe'
    accept_terms true
    tip_preference_in_cents 50
    identities [FactoryGirl.create(:identities_facebook)]
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
