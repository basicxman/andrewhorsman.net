require 'test_helper'

class ReadingItemTest < ActiveSupport::TestCase
  test "should not update reading item when link is blank" do
    ri = ReadingItem.find(1)
    ri.update_attributes :link => ""
    assert_not_nil ri.errors.messages[:link]
  end

  test "should not update reading item when name is blank" do
    ri = ReadingItem.find(1)
    ri.update_attributes :name => ""
    assert_not_nil ri.errors.messages[:name]
  end

  test "should not update reading item when rating is blank" do
    ri = ReadingItem.find(1)
    ri.update_attributes :rating => nil
    assert_not_nil ri.errors.messages[:rating]
  end

  test "should not update reading item when rating is below range" do
    ri = ReadingItem.find(1)
    ri.update_attributes :rating => 0
    assert_not_nil ri.errors.messages[:rating]
  end

  test "should not update reading item when rating is above range" do
    ri = ReadingItem.find(1)
    ri.update_attributes :rating => 11
    assert_not_nil ri.errors.messages[:rating]
  end
end
