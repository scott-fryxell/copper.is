require 'spec_helper'

describe User do
  it 'has a fan' do
    User.create.should respond_to(:fan)
  end
  
  it 'has a author' do
    User.create.should respond_to(:author)
  end
end

__END__
maybe this is just tied together by auth_source....
auth_sources are first class citizens


