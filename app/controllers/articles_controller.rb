class ArticlesController < ApplicationController
  include ApplicationHelper
  respond_to :html, :json, :xml, :rss

  def index
    set(:page, 0)
    expose(:articles, Article.frontpage.limit(get_config(:articles_in_page)))
  end

  def show
    expose(:article, Article.find_by_params(params))
  end

  def multiple
    if params[:page]
      params[:quantity] = get_config(:articles_in_page)
      params[:offset]   = get_config(:articles_in_page) * params[:page].to_i
      set(:page, params[:page])
    end
    expose(:articles, Article.get_quantity(params[:quantity], params[:offset]))
  end
end
