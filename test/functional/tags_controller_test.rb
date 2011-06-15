require 'test_helper'

class TagsControllerTest < ActionController::TestCase
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
