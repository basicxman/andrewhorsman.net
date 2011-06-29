require 'test_helper'

class ReadingItemTest < ActiveSupport::TestCase
  test "should not create reading item when link is blank" do
    ri = Factory.build(:reading_item, :link => "")
    assert_not_nil ri.errors[:link]
  end

  test "should not create reading item when name is blank" do
    ri = Factory.build(:reading_item, :name => "")
    assert_not_nil ri.errors[:name]
  end

  test "should not create reading item when rating is blank" do
    ri = Factory.build(:reading_item, :rating => nil)
    assert_not_nil ri.errors[:rating]
  end

  test "should not create reading item when rating is below range" do
    ri = Factory.build(:reading_item, :rating => 0)
    assert_not_nil ri.errors[:rating]
  end

  test "should not create reading item when rating is above range" do
    ri = Factory.build(:reading_item, :rating => 11)
    assert_not_nil ri.errors[:rating]
  end
end
