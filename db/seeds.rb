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
  { :name => 'Developer' },
])

configurations = Configuration.create([
  { :property => 'fee_percent', :value => '7'},
  { :property => 'default_tip_rate', :value => '50'}
])

