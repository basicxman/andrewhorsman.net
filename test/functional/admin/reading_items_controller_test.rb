require 'test_helper'

class Admin::ReadingItemsControllerTest < ActionController::TestCase
  def setup
    session[:user_id] = 2
  end

  test "should create a new reading item" do
    get :create, :reading_item => { :link => "http://someuniquewebsite.com", :name => "Some Unique Website", :rating => 10 }
    assert_redirected_to admin_path
    assert_equal 3, ReadingItem.count
    assert_equal "http://someuniquewebsite.com", ReadingItem.last.link
  end

  test "should update a previous reading item" do
    get :update, :method => :put, :id => 1, :reading_item => { :link => "http://someuniquething.com", :name => "Google", :rating => 10 }
    assert_redirected_to admin_path
    assert_equal "http://someuniquething.com", ReadingItem.find(1).link
  end

  test "should destroy a previous reading item" do
    get :destroy, :method => :delete, :id => 1
    assert_redirected_to admin_path
    assert_raise(ActiveRecord::RecordNotFound) do
      ReadingItem.find(1)
    end
  end
end
