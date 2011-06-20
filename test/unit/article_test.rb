require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  test "should not update an article if the title is blank" do
    a = Article.find(2)
    a.update_attributes(:title => "")
    assert_not_nil a.errors.messages[:title]
  end

  test "should not update an article if the author is blank" do
    a = Article.find(2)
    a.update_attributes(:author => "")
    assert_not_nil a.errors.messages[:author]
  end

  test "should not update an article if the content is blank" do
    a = Article.find(2)
    a.update_attributes(:content => "")
    assert_not_nil a.errors.messages[:content]
  end
end
