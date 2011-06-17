class ReadingItem < ActiveRecord::Base
  validates_presence_of :link, :name, :rating
  validates_numericality_of :rating, :greater_than => 0, :less_than_or_equal_to => 10, :message => "must be between 1 and 10"

  scope :updated_desc, lambda { order("updated_at DESC") }
end
