require 'spec_helper'

describe AuthSource do
  before do
    @auth_source = AuthSources::Phony.create!(username:'dude')
  end
  
  it 'can belong to an author' do
    @auth_source.create_author!
  end
  
  it 'can belong to a fan' do
    @auth_source.create_fan!
  end
end
