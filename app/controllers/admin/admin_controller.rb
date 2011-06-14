class Admin::AdminController < ApplicationController
  respond_to :html

  def index
    expose(:articles, Article.updated_desc.all)
  end
end
