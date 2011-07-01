require 'test_helper'

class Admin::AdminControllerTest < ActionController::TestCase
  test "should display new article link on console" do
    login_as_admin
    get :index
    assert_select "a[href='/admin/articles/new']"
  end

  test "should display new reading item link on console" do
    login_as_admin
    get :index
    assert_select "a[href='/admin/reading_items/new']"
  end

  test "should display articles table on console" do
    login_as_admin
    get :index
    assert_select "#full-content table#articles-console"
    assert_select "#full-content table#articles-console tbody tr", :count => Article.count
  end

  test "should display a valid show link for a published article" do
    login_as_admin
    article = Factory(:article)
    get :index
    assert_select "a[href=#{article_path(article)}]"
  end

  test "should display a valid show link for an unpublished article" do
    login_as_admin
    article = Factory(:article, :published_at => nil)
    get :index
    assert_select "a[href=#{preview_path(article.hash)}]"
  end

  test "should display reading items table on console" do
    login_as_admin
    get :index
    assert_select "#full-content table#reading-items-console"
    assert_select "#full-content table#reading-items-console tbody tr", :count => ReadingItem.count
  end

  test "should redirect to login form if logged out" do
    get :index
    assert_redirected_to login_form_path(:landing_page => "/admin")
  end

  test "should redirect to login form if a regular user" do
    login_as_user
    get :index
    assert_redirected_to login_form_path(:landing_page => "/admin")
  end

  # Routes
  test "should route to administration console" do
    assert_routing "/admin", { :controller => "admin/admin", :action => "index" }
  end
end
