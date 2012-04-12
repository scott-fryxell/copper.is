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
    # association :role
    name 'Joe'
    accept_terms true
    tip_preference_in_cents 50
  end
  
  factory :tip_order do
    association :user
    state 'current'
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
  
  factory :royalty_check do
    association :user
  end
end