require 'test_helper'

class UserControllerTest < ActionController::TestCase
  def setup
    # Can't place passwords in fixtures using has_secure_password
    u = User.find(1)
    u.password = "test"
    u.save

    u = User.find(2)
    u.password = "testing"
    u.save
  end

  test "should redirect to homepage if already logged in" do
    session[:user_id] = 1

    get :login_form
    assert_redirected_to root_path
  end

  test "should show login form if not logged in" do
    get :login_form
    assert_response :success
    assert_select "#email"
    assert_select "#password"
  end

  test "should successfully login if proper credentials are given" do
    post :login, :email => "self@andrewhorsman.net", :password => "testing"
    assert_redirected_to root_path
    assert_equal session[:user_id], 2
    assert_equal flash[:notice], "Logged in as self@andrewhorsman.net.  Hi Andrew Horsman!"
  end

  test "should display a notice if the login credentials given are invalid" do
    post :login, :email => "self@andrewhorsman.net", :password => "test this!"
    assert_select "#email"
    assert_select "#password"
    assert_nil session[:user_id]
    assert_equal flash[:notice], "Failed to login."
  end

  test "should logout successfully" do
    session[:user_id] = 1
    get :logout
    assert_redirected_to root_path
    assert_equal flash[:notice], "Logged out."
    assert_nil session[:user_id]
  end

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
