require 'test_helper'

class Admin::ReadingItemsControllerTest < ActionController::TestCase
  def setup
    login_as_admin
  end

  test "should create a new reading item" do
    assert_difference("ReadingItem.count", 1) do
      get :create, :reading_item => { :link => "http://someuniquewebsite.com", :name => "Some Unique Website", :rating => 10 }
      assert_redirected_to admin_path
      assert_equal "http://someuniquewebsite.com", ReadingItem.last.link
    end
  end

  test "should update a previous reading item" do
    reading_item = Factory(:reading_item)
    get :update, :method => :put, :id => reading_item.id, :reading_item => { :link => "http://someuniquething.com", :name => "Google", :rating => 10 }
    assert_redirected_to admin_path
    assert_equal "http://someuniquething.com", ReadingItem.find(reading_item.id).link
  end

  test "should destroy a previous reading item" do
    reading_item = Factory(:reading_item)
    get :destroy, :method => :delete, :id => reading_item.id
    assert_redirected_to admin_path
    assert_raise(ActiveRecord::RecordNotFound) do
      ReadingItem.find(reading_item.id)
    end
  end
end
