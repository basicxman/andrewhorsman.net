require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  # Routes
  test "should route to articles index" do
    assert_routing "/articles", { :controller => "articles", :action => "index" }
  end

  test "should route to multiple articles" do
    assert_routing "/articles/multiple/10", { :controller => "articles", :action => "multiple", :quantity => "10" }
  end

  test "should route to multiple articles with an offset" do
    assert_recognizes({ :controller => "articles", :action => "multiple", :quantity => "10", :offset => "20" }, "/articles/multiple/10/from/20")
  end

  test "should route to a page of articles" do
    assert_routing "/articles/page/3", { :controller => "articles", :action => "multiple", :page => "3" }
  end

  test "should route to a single article" do
    assert_routing "/articles/1", { :controller => "articles", :action => "show", :id => "1" }
  end
end
