class Identities::Tumblr < Identity

  def self.discover_uid_and_username_from_url url
    host = URI.parse('http://janebook.tumblr.com/').host
    username = %r{.tumblr.com}.match(host).pre_match
    { :uid => username, :username => username}
  end

  def inform_non_user_of_promised_tips
    super do

    end
  end

  def populate_uid_from_username!
    super do
    end
  end

  def populate_username_from_uid!
    super do
    end
  end

end
