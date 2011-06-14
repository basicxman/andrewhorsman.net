class ArticlesController < ApplicationController
  respond_to :html, :json, :xml

  def index
    expose(:articles, Article.frontpage)
  end

  def show
    expose(:article, Article.find_by_params(params))
  end

  def multiple
    expose(:articles, Article.get_quantity(params[:quantity], params[:offset]))
  end
end
