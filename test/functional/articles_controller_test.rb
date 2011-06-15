require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  test "should get the articles index and display x number of articles" do
    get :index
    assert_response :success
    assert_select ".article-title", :count => get_config(:articles_in_page)
  end

  test "should display most recently updated articles first" do
    get :index
    assert_select ".article-title" do |elements|
      assert_select elements[0], "a", :text => "Published first"
      assert_select elements[1], "a", :text => "Published with future updated at"
    end
  end

  test "should not display articles which aren't yet published" do
    get :index
    assert_select ".article-title", :text => "Generic test article", :count => 0
  end

  test "should display next page link on the index" do
    get :index
    assert_select "a", :title => "Next Page", :href => "/articles/page/1"
  end

  test "should not display a previous page link on the index" do
    get :index
    assert_select "a[title='Previous Page']", 0
  end

  test "should get the next page of articles" do
    get :multiple, :page => 1
    assert_select ".article-title", :count => get_config(:articles_in_page)
    assert_select "a", :text => "Next Page", :href => "/articles/page/2"
    assert_select "a", :text => "Previous Page", :href => "/articles/page/0"
  end

  test "should display an article" do
    get :show, :id => 5
    assert_select ".article-title h2", :text => "Published first"
    assert_select ".article-content", :text => "Testing 1...2...3"
    assert_select ".article-author", :text => "by #{articles(:five).author}"
  end

  test "should properly display next and previous article links" do
    get :show, :id => 5
    assert_select ".prev-article-link", :count => 0
    assert_select ".next-article-link", :count => 1

    get :show, :id => 6
    assert_select ".prev-article-link", :count => 1
    assert_select ".next-article-link", :count => 1

    get :show, :id => 24
    assert_select ".prev-article-link", :count => 1
    assert_select ".next-article-link", :count => 0
  end

  test "should display all tags in an article" do
    get :show, :id => 8
    assert_select ".article-tags ul li", :count => 3
    assert_select ".article-tags ul li", :text => "foo"
    assert_select ".article-tags ul li", :text => "bar"
    assert_select ".article-tags ul li", :text => "test"
  end

  test "should display updated date if after published date" do
    get :show, :id => 6
    assert_select ".article-date", :count => 1
    assert_select ".article-updated-date", :count => 1

    get :show, :id => 7
    assert_select ".article-date", :count => 1
    assert_select ".article-updated-date", :count => 0
  end

  test "should show multiple articles" do
    get :multiple, :quantity => 5
    assert_select ".article-title", :count => 5
    assert_select ".article-title" do |elements|
      assert_select elements[0], "h2", :text => "Published first"
    end
  end

  test "should show multiple articles with offset" do
    get :multiple, :quantity => 5, :offset => 1
    assert_select ".article-title", :count => 5
    assert_select ".article-title" do |elements|
      assert_select elements[0], "h2", :text => "Published with future updated at"
    end
  end

  test "should display titles and taglines properly" do
    get :show, :id => 5
    assert_select "title", "Published first | #{get_config(:main_title)}"
    assert_select "#header h1", :text => get_config(:main_title)
    assert_select "#header p", :text => get_config(:main_tagline)
  end

  test "should hide excess tags when viewing multiple articles" do
    get :multiple, :quantity => 1, :offset => 6
    assert_select ".tag0", :count => 1
    assert_select ".tag1", :count => 1
    assert_select ".tag2", :count => 1
    assert_select ".tag3", :count => 1
    assert_select ".ellipsis-tags", :count => 1
    assert_select ".hidden-tag", :count => 1
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
end
