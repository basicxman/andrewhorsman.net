require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  test "should get the tags index and display n number of articles" do
    get :index
    assert_select ".tags-list ul li", :count => Tag.count
  end

  test "should get the articles for tag foo" do
    get :show, :id => 1
    assert_select ".article-title", :count => 2
    assert_select ".article-title h2", :text => "Article with tags"
    assert_select ".article-title h2", :text => "Article with long tags"
  end

  test "should get the articles for multiple tags" do
    get :show_multiple, :keywords => "bar,some-very-very-very-very-long-tag"
    assert_select ".article-title", :count => 2
    assert_select ".article-title h2", :text => "Article with long tags"
    assert_select ".article-title h2", :text => "Article with tags"
  end

  test "should have the correct tagline and title for tags" do
    get :show_multiple, :keywords => "bar"
    assert_select "#content h3", :text => "Viewing tag bar"
    assert_select "title", "Viewing tag bar | #{get_config(:main_title)}"

    get :show_multiple, :keywords => "bar,foo"
    assert_select "#content h3", :text => "Viewing tags bar and foo"

    get :show_multiple, :keywords => "bar,foo,test"
    assert_select "#content h3", :text => "Viewing tags bar, foo and test"
  end

  # Routes
  test "should route to tags index" do
    assert_routing "/tags", { :controller => "tags", :action => "index" }
  end

  test "should route to a single tag" do
    assert_routing "/tags/1", { :controller => "tags", :action => "show", :id => "1" }
  end

  test "should route to multiple tags" do
    assert_routing "/tags/multiple/foo,bar", { :controller => "tags", :action => "show_multiple", :keywords => "foo,bar" }
  end
end
