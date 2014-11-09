require 'spec_helper'
describe "the entire code base" do
  it 'contains no code smells' do
    expect(Dir['lib/**/*.rb']).not_to reek
    expect(Dir['app/**/*.rb']).not_to reek
  end  
end
