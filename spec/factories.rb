FactoryGirl.define do
  sequence 'uid' do |n|
    n
  end

  sequence 'url_with_path' do |n|
    "http://test.com/#{n}/"
  end

  factory :identity do
    provider 'facebook'
    uid { FactoryGirl.generate(:uid) }
  end

  factory :role do
    name "Patron"
  end

  # factory :unaccepted_user, :class => 'User' do
  # end

  factory :user do
    name 'Joe'
    roles [FactoryGirl.create(:role)]
    accept_terms true
    tip_preference_in_cents 50
    identities [FactoryGirl.create(:identity)]
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
    association :identity
  end

  factory :unauthored_page, :class => 'Page' do
    url { FactoryGirl.generate(:url_with_path) }
  end

  factory :tip do
    association :tip_order
    association :page, factory: :unauthored_page
    amount_in_cents 100
  end

  factory :tip_charged, :class => "Tip" do
    association :tip_order
    association :page, factory: :unauthored_page
    amount_in_cents 100
    state "charged"
  end

  factory :tip_received, :class => "Tip" do
    association :tip_order
    association :page, factory: :unauthored_page
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
