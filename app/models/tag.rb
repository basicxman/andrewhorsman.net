class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  has_many :articles, :through => :taggings

  validates_uniqueness_of :keyword
  validates_presence_of   :keyword
  validates_format_of     :keyword, :with => /^[0-9a-zA-Z\-\?!]+$/

  scope :latest_first, order("created_at DESC")
  scope :frontpage,    lambda { latest_first.all }

  def to_param
    "#{self.id}-#{self.keyword}"
  end

  def weight
    (self.articles.count / Article.count.to_f * 100).round(2)
  end

  def chronological_articles
    self.articles.publishable.latest_first
  end

  def self.find_by_params(params)
    find(params[:id].to_i)
  end

  def self.find_by_keywords(keywords)
    keywords.map { |k| Tag.find_or_create(k) }
  end

  def self.find_or_create(keyword)
    Tag.find_by_keyword(keyword) || Tag.create(:keyword => keyword)
  end
end
