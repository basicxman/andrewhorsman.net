require 'test_helper'

class Admin::AdminControllerTest < ActionController::TestCase
  def login_as_admin
    session[:user_id] = 2
  end

  def login_as_user
    session[:user_id] = 1
  end

  test "should display new article link on console" do
    login_as_admin
    get :index
    assert_select "a[href='/admin/articles/new']"
  end

  test "should display articles table on console" do
    login_as_admin
    get :index
    assert_select "#full-content table"
    assert_select "#full-content table tbody tr", :count => Article.count
  end

  test "should redirect to login form if logged out" do
    get :index
    assert_redirected_to login_form_path
  end

  test "should redirect to login form if a regular user" do
    login_as_user
    get :index
    assert_redirected_to login_form_path
  end

  # Routes
  test "should route to administration console" do
    assert_routing "/admin", { :controller => "admin/admin", :action => "index" }
  end
end
