class Article < ActiveRecord::Base
  include ArticlesHelper

  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings

  validates_presence_of :title, :author, :content

  scope :publishable,  where("published_at IS NOT NULL")
  scope :latest_first, order("published_at DESC")
  scope :updated_desc, order("updated_at DESC")
  scope :frontpage,    publishable.latest_first

  before_save   :process_content_for_html, :if => :content_changed?
  before_create :give_preview

  attr_accessor :file

  def self.article_from_file(path)
    content = File.read(path)
    ArticleProcessing.process_input_file(content)
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

  def self.sphinx_search(query, opts = {})
    opts.merge!({
      :without => { :published_at => "NULL" },
      :order => :updated_at,
      :sort_mode => :desc,
      :per_page => get_config(:articles_in_page),
      :field_weights => { :title => 20, :content => 10, :author_name => 10, :tag_keywords => 10 }
    })
    Article.search(query, opts)
  end

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
    self.published_at && self.published_at < self.updated_at
  end

  def commit
    return false unless can_make_milestone_commit?
    self.stage += 1
    self.last_commit_date = Time.zone.now
    self.save
  end

  def publish
    return false unless can_be_published?
    self.update_attribute :published_at, Time.zone.now
  end

  def unpublish
    self.update_attribute :published_at, nil
  end

  def process_content_for_html
    self.content_html = ArticleProcessing.process_content(self.content)
  end

  def give_preview
    self.preview_hash = UUID.generate
  end

  # Thinking Sphinx
  define_index do
    indexes title, :sortable => true
    indexes content
    indexes author
    indexes tags(:keyword), :as => :tag_keywords

    has published_at
    has updated_at
  end
end
