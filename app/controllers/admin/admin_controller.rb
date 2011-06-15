class Admin::AdminController < ApplicationController
  respond_to :html

  before_filter :authenticate_admin

  def index
    expose(:articles, Article.updated_desc.all)
  end
end
