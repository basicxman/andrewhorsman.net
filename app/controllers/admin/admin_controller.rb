class Admin::AdminController < ApplicationController
  respond_to :html

  before_filter :authenticate_admin

  def index
    set(:articles, Article.updated_desc.all)
    expose(:reading_items, ReadingItem.updated_desc.all)
  end
end
