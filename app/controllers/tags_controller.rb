class TagsController < ApplicationController
  respond_to :html, :json, :xml

  def index
    expose(:tags, Tag.frontpage)
  end

  def show
    set(:tag, Tag.find_by_params(params))
    expose(:articles, @tag.articles)
  end

  def show_multiple
    tags = params[:keywords].split(",")

    set(:noun, tags.length == 1 ? "tag" : "tags")
    set(:tagline, generate_tagline(tags))

    expose(:articles, Article.find_by_tags(tags))
  end

  private
  def generate_tagline(tags)
    tagline = ""
    tags.each_with_index do |keyword, index|
      tagline += if index == 0
        keyword
      elsif index == tags.length - 1
        " and #{keyword}"
      else
        ", #{keyword}"
      end
    end
  end
end
