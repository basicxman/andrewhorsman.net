require 'test_helper'

class Admin::ArticlesControllerTest < ActionController::TestCase
  def setup
    session[:user_id] = 2
  end

  test "should commit an article that was last commited over six hours ago" do
    get :commit, :id => 3
    assert_redirected_to admin_path
    assert_equal "Committed!", flash[:notice]
    assert_equal articles(:four).stage + 1, Article.find(3).stage
  end

  test "should not commit an article which was just committed" do
    get :commit, :id => 4
    assert_redirected_to admin_path
    assert_equal "Unable to commit at this time.", flash[:notice]
    assert_equal articles(:four).stage, Article.find(4).stage
  end

  test "should publish an article if it has reached the final stage" do
    get :publish, :id => 2
    assert_redirected_to admin_path
    assert_equal "Published!", flash[:notice]
    assert_not_nil Article.find(2).published_at
  end

  test "should not publish an article which has not reached the final stage" do
    get :publish, :id => 3
    assert_redirected_to admin_path
    assert_equal "Unable to publish at this time.", flash[:notice]
    assert_nil Article.find(2).published_at
  end

  test "should unpublish an article" do
    get :unpublish, :id => 5
    assert_redirected_to admin_path
    assert_equal "Unpublished.", flash[:notice]
    assert_nil Article.find(5).published_at
  end

  test "should destroy an article" do
    delete :destroy, :id => 5
    assert_redirected_to admin_path
    assert_raise(ActiveRecord::RecordNotFound) do
      Article.find(5)
    end
  end

  test "should update an article" do
    put :update, :id => 2, :article => { :title => "Testing!" }
    assert_redirected_to admin_path
    assert_equal "Testing!", Article.find(2).title
  end

  test "should not update an article if the title is blank" do
    put :update, :id => 2, :article => { :title => "" }
    assert_response :success
    assert_template :edit
  end

  test "should not update an article if the author is blank" do
    put :update, :id => 2, :article => { :author => "" }
    assert_response :success
    assert_template :edit
  end

  test "should not update an article if the content is blank" do
    put :update, :id => 2, :article => { :content => "" }
    assert_response :success
    assert_template :edit
  end

  test "should update tags" do
    put :update, :id => 8, :article => { :tag_list => "foo bar" }
    assert_redirected_to admin_path
    assert Article.find(8).tags.exists? Tag.find_by_keyword("foo")
    assert Article.find(8).tags.exists? Tag.find_by_keyword("bar")
    assert_equal 2, Article.find(8).tags.count
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
