class Article < ActiveRecord::Base
  include ArticlesHelper
  has_many :taggings
  has_many :tags, :through => :taggings

  validates_presence_of :title, :author, :content

  scope :publishable,  lambda { where("published_at IS NOT NULL") }
  scope :latest_first, lambda { order("created_at DESC") }
  scope :updated_desc, lambda { order("updated_at DESC") }
  scope :frontpage,    lambda { publishable.latest_first }

  attr_accessor :file

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

  def recently_updated?
    self.published_at < self.updated_at
  end

  def commit
    return false unless can_make_milestone_commit?
    self.stage += 1
    self.last_commit_date = Time.zone.now
    self.save
  end

  def publish
    return false unless can_be_published?
    self.update_attributes :published_at => Time.zone.now
  end

  def unpublish
    self.update_attributes :published_at => nil
  end

  def self.new_article_from_file(path)
    content = File.read(path)
    Article.new(process_article_file_contents(content))
  end

  def self.available_pages
    (Article.count.to_f / Site::Application.config.articles_in_page).ceil
  end

  def self.get_quantity(quantity = 1, offset = 0)
    frontpage.offset(offset).limit(quantity)
  end

  def self.find_by_params(params)
    find(params[:id].to_i)
  end

  def self.find_by_tags(tags)
    publishable.find(:all, :include => :tags, :conditions => ["tags.keyword IN (?)", tags])
  end

  private

  def self.header_var(string, var)
    m = string.match(/^@#{var}:\s*(.*)$/)
    m.nil?? "" : m[1]
  end

  def self.process_article_file_contents(data)
    contents = data.split("\n")
    header   = ""
    index    = 0
    contents.each do |line|
      break if line.blank?
      header += line + "\n"
      index += 1
    end

    title   = header_var(header, "title")
    author  = header_var(header, "author")
    tags    = header_var(header, "tags")
    content = contents[index + 1..-1].join("\n")

    { :title => title, :author => author, :tag_list => tags, :content => content }
  end

end
