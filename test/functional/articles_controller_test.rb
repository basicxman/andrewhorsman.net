require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  test "should get the articles index and display x number of articles" do
    overflow_with_articles
    get :index
    assert_response :success
    assert_select ".article-title", :count => get_config(:articles_in_page)
  end

  test "should display most recently updated articles first" do
    Factory(:article, :title => "First")
    Factory(:article, :published_at => Time.zone.now + 10.hours, :title => "Second")
    get :index
    assert_select ".article-title" do |elements|
      assert_select elements[0], "a", :text => "Second"
      assert_select elements[1], "a", :text => "First"
    end
  end

  test "should not display articles which aren't yet published" do
    title = "Generic test article"
    Factory(:article, :published_at => nil, :title => title)
    get :index
    assert_select ".article-title", :text => title, :count => 0
  end

  test "should display next page link on the index" do
    overflow_with_articles
    get :index
    assert_select "a", :title => "Next Page", :href => "/articles/page/1"
  end

  test "should not display a previous page link on the index" do
    overflow_with_articles
    get :index
    assert_select "a[title='Previous Page']", 0
  end

  test "should get the next page of articles" do
    2.times { overflow_with_articles }
    get :multiple, :page => 1
    assert_select ".article-title", :count => get_config(:articles_in_page)
    assert_select "a", :text => "Next Page", :href => "/articles/page/2"
    assert_select "a", :text => "Previous Page", :href => "/articles/page/0"
  end

  test "should display an article" do
    article = Factory(:article, :title => "Testing")
    get :show, :id => article.id
    assert_select ".article-title h2", :text => "#{article.title}"
    assert_select ".article-author", :text => "by #{article.author}"
  end

  test "should properly display next and previous article links" do
    overflow_with_articles
    get :show, :id => Article.publishable.first.id
    assert_select ".prev-article-link", :count => 0
    assert_select ".next-article-link", :count => 1

    get :show, :id => Article.publishable.first.id + 1
    assert_select ".prev-article-link", :count => 1
    assert_select ".next-article-link", :count => 1

    get :show, :id => Article.publishable.last.id
    assert_select ".prev-article-link", :count => 1
    assert_select ".next-article-link", :count => 0
  end

  test "should display all tags in an article" do
    article = Factory(:article)
    article.tags += [Tag.find_or_create("foo"), Tag.find_or_create("bar"), Tag.find_or_create("test")]
    get :show, :id => article.id
    assert_select ".article-tags ul li", :count => 3
    assert_select ".article-tags ul li", :text => "foo"
    assert_select ".article-tags ul li", :text => "bar"
    assert_select ".article-tags ul li", :text => "test"
  end

  test "should display updated date if after published date" do
    a = Factory(:article, :updated_at => Time.zone.now + 10.hours)
    get :show, :id => a.id
    assert_select ".article-date", :count => 1
    assert_select ".article-updated-date", :count => 1

    a = Factory(:article, :updated_at => Time.zone.now - 10.hours)
    get :show, :id => a.id
    assert_select ".article-date", :count => 1
    assert_select ".article-updated-date", :count => 0
  end

  test "should show multiple articles" do
    overflow_with_articles
    get :multiple, :quantity => 5
    assert_select ".article-title", :count => 5
    assert_select ".article-title" do |elements|
      assert_select elements[0], "h2", :text => Article.publishable.last.title
    end
  end

  test "should show multiple articles with offset" do
    overflow_with_articles
    get :multiple, :quantity => 5, :offset => 1
    assert_select ".article-title", :count => 5
    assert_select ".article-title" do |elements|
      assert_select elements[0], "h2", :text => Article.publishable[-2].title
    end
  end

  test "should display titles and taglines properly" do
    article = Factory(:article, :title => "Testing")
    get :show, :id => article.id
    assert_select "title", "Testing | #{get_config(:main_title)}"
    assert_select "#header h1", :text => get_config(:main_title)
    assert_select "#header p", :text => get_config(:main_tagline)
  end

  test "should hide excess tags when viewing multiple articles" do
    article = Factory(:article)
    5.times { article.tags << Factory(:tag) }
    get :multiple, :quantity => 1
    assert_select ".tag0", :count => 1
    assert_select ".tag1", :count => 1
    assert_select ".tag2", :count => 1
    assert_select ".tag3", :count => 1
    assert_select ".ellipsis-tags", :count => 1
    assert_select ".hidden-tag", :count => 1
  end

  test "should not be able to see an unpublished article" do
    article = Factory(:article, :published_at => nil)
    assert_raise(ActiveRecord::RecordNotFound) do
      get :show, :id => article.id
    end
  end

  test "should get an article via a preview" do
    article = Factory(:article)
    get :preview, :hash => article.preview_hash
    assert_response :success
    assert_select ".article-title", article.title
  end

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

  private

  def overflow_with_articles
    (get_config(:articles_in_page) + 1).times { Factory(:article) }
  end
end
