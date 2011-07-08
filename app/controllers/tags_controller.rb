class TagsController < ApplicationController
  include TagsHelper
  respond_to :html, :json, :xml

  def index
    expose(:tags, Tag.frontpage)
  end

  def show
    set(:tag, Tag.find_by_params(params))
    expose(:articles, @tag.chronological_articles)
  end

  def show_multiple
    tags = params[:keywords].split(",")

    set(:noun, tags.length == 1 ? "tag" : "tags")
    set(:tagline, tags.to_sentence(:last_word_connector => " and "))

    expose(:articles, Article.find_by_tags(tags))
  end
end
