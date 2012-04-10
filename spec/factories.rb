FactoryGirl.define do
  sequence 'uid' do |n|
    n
  end
  
  sequence 'url_with_path' do |n|
    "test.com/#{n}/"
  end
  
  factory :identity do
    provider 'facebook'
    uid { Factory.generate(:uid) } 
  end
  
  # factory :unaccepted_user, :class => 'User' do
  # end
  
  factory :user do
    role 'Patron'
    name 'Joe'
    accept_terms true
  end
  
  factory :tip_order do
    association :user
  end
  
  factory :page do
    url { Factory.generate(:url_with_path) }
  end
  
  factory :tip do
    association :tip_order
    association :page
    amount_in_cents 100
  end
end