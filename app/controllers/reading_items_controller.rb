class ReadingItemsController < ApplicationController
  respond_to :html, :json, :xml, :rss, :txt

  def list
    expose(:reading_items, ReadingItem.updated_desc.all)
  end
end
