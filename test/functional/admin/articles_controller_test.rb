require 'test_helper'

class Admin::ArticlesControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

  test "should get commit" do
    get :commit
    assert_response :success
  end

  test "should get publish" do
    get :publish
    assert_response :success
  end

  test "should get unpublish" do
    get :unpublish
    assert_response :success
  end

end
