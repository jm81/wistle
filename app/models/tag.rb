class Tag
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  
  has n, :taggings
  has n, :articles, :through => :taggings
end