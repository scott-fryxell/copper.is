require 'spec_helper'
describe "the entire code base" do
  it 'contains no code smells' do
    Dir['lib/**/*.rb'].should_not reek
    Dir['app/**/*.rb'].should_not reek
  end  
end
