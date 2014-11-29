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

  factory :user do

    name 'Joe'
    accept_terms true
    tip_preference_in_cents 50
    roles [Role.find_or_create_by(name:'fan')]

    trait :can_give do
      can_give true
    end

    trait :can_receive do
      can_recieve true
    end

    factory :admin do
      roles [Role.find_or_create_by(name:'admin')]
    end

    factory :user_with_email do
      email 'scott+test@copper.is'
    end

    factory :user_can_give, traits:[:can_give]
    factory :user_can_receive, traits:[:can_give]

    factory :user_with_facebook_author do
      transient do
        authors_count 1
      end
      after(:create) do |user, evaluator|
        FactoryGirl.create_list(:author_facebook, evaluator.authors_count, user: user)
      end
    end
  end

  factory :author do
    username { FactoryGirl.generate(:username) }
    uid { FactoryGirl.generate(:uid) }
    provider:'phony'

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

    factory :author_youtube,    traits: [:youtube, :stranger],    class: 'Authorizer::Youtube'
    factory :author_soundcloud, traits: [:soundcloud, :stranger], class: 'Authorizer::Soundcloud'
    factory :author_github,     traits: [:github, :stranger],     class: 'Authorizer::Github'
    factory :author_tumblr,     traits: [:tumblr, :stranger],     class: 'Authorizer::Tumblr'
    factory :author_flickr,     traits: [:flickr, :stranger],     class: 'Authorizer::Flickr'
    factory :author_vimeo,      traits: [:vimeo, :stranger],      class: 'Authorizer::Vimeo'
    factory :author_google,     traits: [:google, :stranger],     class: 'Authorizer::Google'
    factory :author_twitter,    traits: [:twitter, :stranger],    class: 'Authorizer::Twitter'
    factory :author_facebook,   traits: [:facebook, :stranger],   class: 'Authorizer::Facebook'
    factory :author_phony,      traits: [:phony, :stranger],      class: 'Authorizer::Phony'
  end

  factory :page do

    url { FactoryGirl.generate(:twitter_url_with_path) }

    trait :adopted do
      author_state 'adopted'
    end

    factory :adopted_page, traits:[:adopted]

  end

  factory :tip do

    association :order
    association :page
    amount_in_cents 100
    created_at 1.week.ago

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
      association :order, factory: :order
    end

    factory :tip_charged do
      to_create {|instance| instance.save(validate: false) }
      charged
      association :order, factory: :order_paid
    end

    factory :tip_kinged do
      to_create {|instance| instance.save(validate: false) }
      kinged
      association :order, factory: :order_paid
      association :check, factory: :check_cashed
   end

  end

  factory :order do

    transient do
      tips_count 5
    end
    order_state 'current'
    association :user

    trait :current do
      order_state 'current'
    end

    trait :unpaid do
      order_state 'unpaid'
      association :user, factory: :user_can_give, strategy: :build
    end

    trait :paid do
      order_state 'paid'
      association :user, factory: :user_can_give, strategy: :build
    end

    trait :denied do
      order_state 'denied'
      association :user, factory: :user_can_give, strategy: :build
    end

    factory :order_billable do
      current
      association :user, factory: :user_can_give, strategy: :build
      after(:create) do |order, evaluator|
        create_list(:tip, evaluator.tips_count, order:order)
      end

    end

    factory :order_unpaid,  traits: [:unpaid]
    factory :order_paid,    traits: [:paid]
    factory :order_denied,  traits: [:denied]

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
