class Preview < ActiveRecord::Base
  belongs_to :article

  def self.find_article_by_hash(hash)
    Preview.find_by_hash_id(hash).article
  end
end
