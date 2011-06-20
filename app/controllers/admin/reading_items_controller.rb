class Admin::ReadingItemsController < ApplicationController
  respond_to :html

  before_filter :authenticate_admin

  def new
    expose(:reading_item, ReadingItem.new)
  end

  def create
    @reading_item = ReadingItem.new(params[:reading_item])
    redirect_or_render(admin_path, :new) do
      @reading_item.save
    end
  end

  def edit
    expose(:reading_item, ReadingItem.find(params[:id]))
  end

  def update
    @reading_item = ReadingItem.find(params[:id])
    redirect_or_render(admin_path, :edit) do
      @reading_item.update_attributes(params[:reading_item])
    end
  end

  def destroy
    @reading_item = ReadingItem.find(params[:id])
    @reading_item.destroy
    redirect_to admin_path
  end
end
