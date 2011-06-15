require 'test_helper'

class Admin::AdminControllerTest < ActionController::TestCase
  # Routes
  test "should route to administration console" do
    assert_routing "/admin", { :controller => "admin/admin", :action => "index" }
  end
end
