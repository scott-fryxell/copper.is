# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

roles = Role.create([
  { :name => 'Patron' },
  { :name => 'Publisher' }, 
  { :name => 'Guest' }, 
  { :name => 'Administrator' }, 
  { :name => 'Developer' }
])

card_types = CardType.create([
  { :name => 'visa' },
  { :name => 'mastercard' },
  { :name => 'discover' },
  { :name => 'americanexpress' }
])

(1..31).each do |id|
  BillingPeriod.create(:id => id)
end
