require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "it should be able to mass assign the password field" do
    user = User.create(:email => "foo@bar.com", :name => "John Smith", :password => "test")
    assert_not_nil user.password_digest
  end
end
