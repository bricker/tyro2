class Comment < ActiveRecord::Base
  belongs_to :commenter, :class_name => 'User'
  belongs_to :commentable, :polymorphic => true
  
  validates_presence_of :body, :commenter_id, :commentable_id, :commentable_type
  
  default_scope order('created_at')
end
