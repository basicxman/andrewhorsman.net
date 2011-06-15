require 'test_helper'

class UserControllerTest < ActionController::TestCase
  # Routes
  test "should route to end-user login form" do
    assert_routing "/login_form", { :controller => "user", :action => "login_form" }
  end

  test "should route to login process" do
    assert_routing({ :path => "/login", :method => :post }, { :controller => "user", :action => "login" })
  end

  test "should route to logout process" do
    assert_routing "/logout", { :controller => "user", :action => "logout" }
  end
end
