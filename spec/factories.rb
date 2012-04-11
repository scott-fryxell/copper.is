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
  end
  
  factory :tip_order do
    association :user
  end
  
  factory :page do
    url { FactoryGirl.generate(:url_with_path) }
  end
  
  factory :tip do
    association :tip_order
    association :page
    amount_in_cents 100
  end
end