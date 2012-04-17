FactoryGirl.define do
  sequence 'uid' do |n|
    n
  end

  sequence 'url_with_path' do |n|
    "http://test.com/#{n}/"
  end

  factory :identities_facebook, class: 'Identities::Facebook' do
    provider 'facebook'
    uid { FactoryGirl.generate(:uid) }
  end
  
  factory :identities_twitter, class: 'Identities::Twitter' do
    provider 'twitter'
    uid { FactoryGirl.generate(:uid) }
  end

  factory :identities_google, class: 'Identities::Google' do
    provider 'google'
    uid { FactoryGirl.generate(:uid) }
  end

  factory :identities_vimeo, class: 'Identities::Vimeo' do
    provider 'vimeo'
    uid { FactoryGirl.generate(:uid) }
  end

  factory :identities_flickr, class: 'Identities::Flickr' do
    provider 'flickr'
    uid { FactoryGirl.generate(:uid) }
  end

  factory :identities_tumblr, class: 'Identities::Tumblr' do
    provider 'tumblr'
    uid { FactoryGirl.generate(:uid) }
  end

  factory :identities_github, class: 'Identities::Github' do
    provider 'github'
    uid { FactoryGirl.generate(:uid) }
  end

  factory :identities_soundcloud, class: 'Identities::Soundcloud' do
    provider 'soundclould'
    uid { FactoryGirl.generate(:uid) }
  end

  factory :identities_youtube, class: 'Identities::Youtube' do
    provider 'youtube'
    type 'Youtube'
    uid { FactoryGirl.generate(:uid) }
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

  factory :tip_order do
    association :user
  end

  factory :tip_order_ready, :class => 'TipOrder' do
    association :user
    state 'ready'
  end

  factory :tip_order_paid, :class => 'TipOrder' do
    association :user
    state 'paid'
  end

  factory :tip_order_declined, :class => 'TipOrder' do
    association :user
    state 'declined'
  end

  factory :authored_page, :class => 'Page' do
    url { FactoryGirl.generate(:url_with_path) }
    association :identity, factory: :identities_twitter
  end

  factory :page do
    url { FactoryGirl.generate(:url_with_path) }
  end

  factory :tip do
    association :tip_order
    association :page
    amount_in_cents 100
  end

  factory :tip_charged, :class => "Tip" do
    association :tip_order
    association :page
    amount_in_cents 100
    state "charged"
  end

  factory :tip_received, :class => "Tip" do
    association :tip_order
    association :page
    amount_in_cents 100
    state "received"
  end

  factory :royalty_check do
    association :user
  end
  
  factory :royalty_check_paid, :class => 'RoyaltyCheck' do
    association :user
    state 'paid'
  end
  
  factory :royalty_check_cashed, :class => 'RoyaltyCheck' do
    association :user
    state 'cashed'
  end
end
