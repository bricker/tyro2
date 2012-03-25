class Tag < ActiveRecord::Base
  has_many :taggings
  validates_presence_of :name
  
  after_create :expire_tags
  def expire_tags
    ActionController::Base.new.expire_fragment('tags')
  end
  
  def to_param
    name
  end
end
