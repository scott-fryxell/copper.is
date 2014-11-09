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
    "https://twitter.com/_1#{n}"
  end

  factory :role do
    name "Fan"
  end

  factory :author do
    username { FactoryGirl.generate(:username) }
    uid { FactoryGirl.generate(:uid) }

    trait :phony do
      provider 'phony'
    end

    trait :facebook do
      provider 'facebook'
    end

    trait :twitter do
      provider 'twitter'
    end

    trait :google do
      provider 'google'
    end

    trait :vimeo do
      provider 'vimeo'
    end

    trait :flickr do
      provider 'flickr'
    end

    trait :tumblr do
      provider 'tumblr'
    end

    trait :github do
      provider 'github'
    end

    trait :soundcloud do
      provider 'soundcloud'
    end

    trait :youtube do
      provider 'youtube'
    end

    trait :stranger do
      identity_state 'stranger'
    end

    trait :wanted do
      identity_state 'wanted'
    end

    trait :known do
      identity_state 'known'
    end

    factory :author_youtube, traits: [:youtube, :stranger], class: 'Authors::Youtube'
    factory :author_soundcloud, traits: [:soundcloud, :stranger], class: 'Authors::Soundcloud'
    factory :author_github, traits: [:github, :stranger], class: 'Authors::Github'
    factory :author_tumblr, traits: [:tumblr, :stranger], class: 'Authors::Tumblr'
    factory :author_flickr, traits: [:flickr, :stranger], class: 'Authors::Flickr'
    factory :author_vimeo, traits: [:vimeo, :stranger], class: 'Authors::Vimeo'
    factory :author_google, traits: [:google, :stranger], class: 'Authors::Google'
    factory :author_twitter, traits: [:twitter, :stranger], class: 'Authors::Twitter'
    factory :author_facebook,traits: [:facebook, :stranger],  class: 'Authors::Facebook'
    factory :author_phony, traits: [:phony, :stranger], class: 'Authors::Phony'
  end

  factory :user do
    name 'Joe'
    accept_terms true
    tip_preference_in_cents 50
    roles [Role.find_or_create_by(name:'Fan')]

    factory :admin do
      roles [Role.find_or_create_by(name:'Admin')]
    end

    factory :user_with_email do
      email 'scott+test@copper.is'
    end

    factory :user_with_facebook_author do
      transient do
        authors_count 1
      end
      after(:create) do |user, evaluator|
        FactoryGirl.create_list(:author_facebook, evaluator.authors_count, user: user)
      end
    end
  end

  factory :order do
    association :user

    trait :current do
      order_state 'current'
    end

    trait :unpaid do
      order_state 'unpaid'
    end

    trait :paid do
      order_state 'paid'
    end

    trait :denied do
      order_state 'denied'
    end

    factory :order_current, traits: [:current]
    factory :order_unpaid, traits: [:unpaid]
    factory :order_paid, traits: [:paid]
    factory :order_denied, traits: [:denied]
  end

  factory :page do
    url { FactoryGirl.generate(:twitter_url_with_path) }
    factory :authored_page do
      author_state 'adopted'
      association :author, factory: :author_twitter
    end
  end

  factory :tip do
    association :order, factory: :order_current
    association :page
    amount_in_cents 100

    trait :promised do
      paid_state 'promised'
    end

    trait :charged do
      paid_state 'charged'
    end

    trait :kinged do
      paid_state 'kinged'
    end

    factory :tip_promised do
      promised
      association :order, factory: :order_current
    end

    factory :tip_charged do
      charged
      association :order, factory: :order_paid
    end

    factory :tip_kinged do
      kinged
      association :order, factory: :order_paid
      association :check, factory: :check_paid
   end
  end

  factory :check do
    association :user

    trait :earned do
      check_state 'earned'
    end

    trait :paid do
      check_state 'paid'
    end

    trait :cashed do
      check_state 'cashed'
    end

    factory :check_earned, traits: [:earned]
    factory :check_paid, traits: [:paid]
    factory :check_cashed, traits: [:cashed]
  end
end
