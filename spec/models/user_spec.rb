require 'spec_helper'

describe User do
  it 'is a collection of AuthSources' do
    User.create.should respond_to(:auth_sources)
  end
  
  it 'can contain both'
end

__END__
maybe this is just tied together by auth_source....
auth_sources are first class citizens


