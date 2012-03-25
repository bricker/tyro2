class Subscription < ActiveRecord::Base
  belongs_to :subscribable, :polymorphic => true
  belongs_to :subscriber, :class_name => "User"
  
  # TODO: One-page in profile for managing subscriptions
end
