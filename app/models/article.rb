class Article < ActiveRecord::Base
  has_and_belongs_to_many :tags

  validates_presence_of [:title, :author, :content]

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

  def tag_list=(list)
    self.tags = Tag.find_by_keywords(list.split(' '))
  end

  def tag_list
    self.tags.map(&:keyword).join(' ')
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

  def can_make_milestone_commit?
    return true if self.last_commit_date.nil?

    delta = Site::Application.config.required_commit_time_delta
    a = self.last_commit_date + delta.hour
    Time.zone.now > a
  end

  def can_be_published?
    self.stage >= Site::Application.config.required_milestone_commits 
  end

  def commit
    if can_make_milestone_commit?
      self.stage += 1
      self.last_commit_date = Time.zone.now
      self.save
    else
      return false
    end
  end

  def publish
    if can_be_published?
      self.published_at = Time.zone.now
      self.save
    else
      return false
    end
  end

  def unpublish
    self.published_at = nil
    self.save
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

  def self.updated_desc
    order("updated_at DESC")
  end

  def self.find_by_params(params)
    find(params[:id].to_i)
  end

  def self.find_by_tags(tags)
    publishable.find(:all, :include => :tags, :conditions => ["tags.keyword IN (?)", tags])
  end
end
