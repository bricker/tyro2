class NewsPost < ActiveRecord::Base
  validates_presence_of :title, :body
  
  default_scope order('created_at DESC')
end
