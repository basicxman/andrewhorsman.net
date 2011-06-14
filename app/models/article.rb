class Article < ActiveRecord::Base
  has_and_belongs_to_many :tags

  validates_presence_of [:title, :author, :content]

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

  def next
    nil unless next_available?
    Article.publishable.order("id ASC").where("id > ?", self.id).limit(1).first
  end

  def prev
    nil unless prev_available?
    Article.publishable.order("id DESC").where("id < ?", self.id).limit(1).first
  end 

  def next_available?
    Article.frontpage.where("id > ?", self.id).count > 0
  end

  def prev_available?
    Article.frontpage.where("id < ?", self.id).count > 0
  end

  def self.get_quantity(quantity = 1, offset = 0)
    frontpage.offset(offset).limit(quantity)
  end

  def self.publishable
    where("published_at IS NOT NULL")
  end

  def self.frontpage
    publishable.latest_first
  end

  def self.latest_first
    order("created_at DESC")
  end

  def self.find_by_params(params)
    find(params[:id].to_i)
  end

  def self.find_by_tags(tags)
    find(:all, :include => :tags, :conditions => ["tags.keyword IN (?)", tags])
  end
end
