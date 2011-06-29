require 'test_helper'

class Admin::ArticlesControllerTest < ActionController::TestCase
  def setup
    login_as_admin
    @article = Factory(:article)
  end

  test "should commit an article that was last commited over six hours ago" do
    a = Factory(:article, :last_commit_date => Time.zone.now - 7.hours)
    assert_difference("Article.find(a.id).stage", 1) do
      get :commit, :id => a.id
      assert_redirected_to admin_path
      assert_equal "Committed!", flash[:notice]
    end
  end

  test "should not commit an article which was just committed" do
    assert_no_difference("Article.find(@article.id).stage") do
      get :commit, :id => @article.id
      assert_redirected_to admin_path
      assert_equal "Unable to commit at this time.", flash[:notice]
    end
  end

  test "should publish an article if it has reached the final stage" do
    @article.update_attributes(:published_at => nil)
    get :publish, :id => @article.id
    assert_redirected_to admin_path
    assert_equal "Published!", flash[:notice]
    assert_not_nil Article.find(@article.id).published_at
  end

  test "should not publish an article which has not reached the final stage" do
    @article.update_attributes(:stage => 2, :published_at => nil)
    get :publish, :id => @article.id
    assert_redirected_to admin_path
    assert_equal "Unable to publish at this time.", flash[:notice]
    assert_nil Article.find(@article.id).published_at
  end

  test "should unpublish an article" do
    get :unpublish, :id => @article.id
    assert_redirected_to admin_path
    assert_equal "Unpublished.", flash[:notice]
    assert_nil Article.find(@article.id).published_at
  end

  test "should destroy an article" do
    delete :destroy, :id => @article.id
    assert_redirected_to admin_path
    assert_raise(ActiveRecord::RecordNotFound) do
      Article.find(@article.id)
    end
  end

  test "should update an article" do
    put :update, :id => @article.id, :article => { :title => "Testing!" }
    assert_redirected_to admin_path
    assert_equal "Testing!", Article.find(@article.id).title
  end

  test "should update tags" do
    put :update, :id => @article.id, :article => { :tag_list => "foo bar" }
    assert_redirected_to admin_path
    assert Article.find(@article.id).tags.exists? Tag.find_by_keyword("foo")
    assert Article.find(@article.id).tags.exists? Tag.find_by_keyword("bar")
    assert_equal 2, Article.find(@article.id).tags.count
  end

  # Routes
  test "should route to an article commit operation" do
    assert_routing "/admin/articles/1/commit", { :controller => "admin/articles", :action => "commit", :id => "1" }
  end

  test "should route to an article publish operation" do
    assert_routing "/admin/articles/1/publish", { :controller => "admin/articles", :action => "publish", :id => "1" }
  end

  test "should route to an article unpublish operation" do
    assert_routing "/admin/articles/1/unpublish", { :controller => "admin/articles", :action => "unpublish", :id => "1" }
  end

  test "should route to create an article" do
    assert_routing({ :path => "/admin/articles", :method => :post }, { :controller => "admin/articles", :action => "create" })
  end

  test "should route to delete an article" do
    assert_routing({ :path => "/admin/articles/1", :method => :delete }, { :controller => "admin/articles", :action => "destroy", :id => "1" })
  end

  test "should route to update an article" do
    assert_routing({ :path => "/admin/articles/1", :method => :put }, { :controller => "admin/articles", :action => "update", :id => "1" })
  end

  test "should route to a new article form" do
    assert_routing "/admin/articles/new", { :controller => "admin/articles", :action => "new" }
  end
end
