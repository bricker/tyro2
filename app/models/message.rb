class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic, :counter_cache => true
  
  validates_presence_of :body, :user_id
  after_create :update_topic
  
  PerPage = 7
  paginates_per PerPage
  default_scope order('messages.created_at').includes(:user)
  has_attached_file :asset,
                    :url => "/assets/message/:id/:basename.:extension",
                    :path => ":rails_root/public/assets/message/:id/:basename.:extension"
  
  after_create :notify_topic_subscribers
    def notify_topic_subscribers
      topic.subscribers.each { |subscriber| SubscriptionMailer.delay.topic_activity(subscriber.name, subscriber.email, self, topic) }
    end
    
  def forum
    topic.forum
  end
  
  def initial_message? # used to change edit link in post partial to edit topic instead.
    topic.initial_message == self
  end
  
  def update_topic
    topic.update_attribute('updated_at', created_at)
  end
end
