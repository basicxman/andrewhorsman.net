class Admin::ArticlesController < ApplicationController
  respond_to :html

  def new
    expose(:article, Article.new)
  end

  def edit
    expose(:article, Article.find_by_params(params))
  end

  def create
    @article = Article.new(params[:article])
    redirect_or_render(admin_path, :new) do
      @article.save
    end
  end

  def update
    @article = Article.find_by_params(params)
    redirect_or_render(admin_path, :edit) do
      @article.update_attributes(params[:article])
    end
  end

  def destroy
    Article.find_by_params(params).destroy
    redirect_to admin_path
  end

  def commit
    notice = commit_notice(Article.find_by_params(params).commit)
    redirect_to admin_path, :notice => notice
  end

  def publish
    notice = publish_notice(Article.find_by_params(params).publish)
    redirect_to admin_path, :notice => notice
  end

  def unpublish
    Article.find_by_params(params).unpublish
    redirect_to admin_path, :notice => "Unpublished."
  end

  private
  
  def commit_notice(b)
    b ? "Committed!" : "Unable to commit at this time."
  end

  def publish_notice(b)
    b ? "Published!" : "Unable to publish at this time."
  end
end
