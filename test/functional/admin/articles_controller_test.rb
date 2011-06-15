require 'test_helper'

class Admin::ArticlesControllerTest < ActionController::TestCase
  # Routes
  test "should route to an article commit operation" do
    assert_routing "/admin/articles/1/commit", { :controller => "admin/articles", :action => "commit", :id => "1" }
  end

  test "should route to an article publish operation" do
    assert_routing "/admin/articles/1/publish", { :controller => "admin/articles", :action => "publish", :id => "1" }
  end

  test "should route to an article unpublish operation" do
    assert_routing "/admin/articles/1/unpublish", { :controller => "admin/articles", :action => "unpublish", :id => "1" }
  end

  test "should route to create an article" do
    assert_routing({ :path => "/admin/articles", :method => :post }, { :controller => "admin/articles", :action => "create" })
  end

  test "should route to delete an article" do
    assert_routing({ :path => "/admin/articles/1", :method => :delete }, { :controller => "admin/articles", :action => "destroy", :id => "1" })
  end

  test "should route to update an article" do
    assert_routing({ :path => "/admin/articles/1", :method => :put }, { :controller => "admin/articles", :action => "update", :id => "1" })
  end

  test "should route to a new article form" do
    assert_routing "/admin/articles/new", { :controller => "admin/articles", :action => "new" }
  end
end
