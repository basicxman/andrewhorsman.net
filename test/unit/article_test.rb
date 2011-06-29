require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  test "should not create an article if the title is blank" do
    a = Factory.build(:article, :title => "")
    assert_not_nil a.errors[:title]
  end

  test "should not create an article if the author is blank" do
    a = Factory.build(:article, :author => "")
    assert_not_nil a.errors[:author]
  end

  test "should not create an article if the content is blank" do
    a = Factory.build(:article, :content => "")
    assert_not_nil a.errors[:content]
  end
end
