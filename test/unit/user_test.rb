require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup :activate_authlogic

  def test_should_be_valid
    # basic user setup
    chub = User.new
    chub.email = "chub@rumpkin.com"
    chub.password = 'test0r'
    chub.password_confirmation = 'test0r'

    assert_nil controller.session["user_credentials"]
    assert UserSession.create(chub)
    assert_equal controller.session["user_credentials"], chub.persistence_token
    assert chub.valid?
  end
end
