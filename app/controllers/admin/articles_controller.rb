class Admin::ArticlesController < ApplicationController
  respond_to :html, :txt

  before_filter :authenticate_admin

  def new
    expose(:article, Article.new)
  end

  def edit
    expose(:article, Article.find_by_params(params))
  end

  def show
    expose(:article, Article.find_by_params(params))
  end

  def create
    @article = Article.new(get_article_params)
    redirect_or_render(admin_path, :new) do
      @article.save
    end
  end

  def update
    @article = Article.find_by_params(params)
    redirect_or_render(admin_path, :edit) do
      @article.update_attributes(get_article_params)
    end
  end

  def destroy
    set(:id, params[:id].to_i)
    Article.find_by_params(params).destroy
    redirect_or_js :redirect_path => admin_path
  end

  def commit
    operation_action(:commit, :commit_notice)
  end

  def publish
    operation_action(:publish, :publish_notice)
  end

  def unpublish
    operation_action(:unpublish, "Unpublished.")
  end

  private

  def operation_action(model_method, notice_method = nil)
    set(:article, Article.find_by_params(params))
    result = @article.send(model_method)

    if notice_method.is_a? String
      flash.now[:notice] = notice_method
    elsif notice_method.is_a? Symbol
      flash.now[:notice] = send(notice_method, result)
    end

    redirect_or_js :redirect_path => admin_path, :js => "operation"
  end

  def get_article_params
    if params[:article][:file]
      Article.article_from_file(params[:article][:file].tempfile)
    else
      params[:article]
    end
  end
  
  def commit_notice(b)
    b ? "Committed!" : "Unable to commit at this time."
  end

  def publish_notice(b)
    b ? "Published!" : "Unable to publish at this time."
  end
end
