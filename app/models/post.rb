class Post < ActiveRecord::Base
  ## SHOW Posts.
  belongs_to :show
  belongs_to :user
  
  validates_presence_of :title, :body, :show_id, :user_id
  
  default_scope order("created_at DESC")
end
