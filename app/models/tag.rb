class Tag < ActiveRecord::Base
  has_and_belongs_to_many :articles

  validates_uniqueness_of :keyword
  validates_presence_of   :keyword
  validates_format_of     :keyword, :with => /^[0-9a-zA-Z\-\?!]+$/

  def to_param
    "#{self.id}-#{self.keyword}"
  end

  def self.latest_first
    order("created_at DESC")
  end

  def self.frontpage
    latest_first.all
  end

  def self.find_by_params(params)
    find(params[:id].to_i)
  end

  def self.find_or_create(keyword)
    t = Tag.find_by_keyword(keyword)
    t = Tag.create(:keyword => keyword) if t.nil?
    t
  end
end
