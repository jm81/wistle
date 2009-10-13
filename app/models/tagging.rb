class Tagging
  include DataMapper::Resource
  extend Paginate::DM
  
  property :id, Serial
  property :article_id, Integer
  property :tag_id, Integer
  
  belongs_to :tag
  belongs_to :article
end