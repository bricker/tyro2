class Topic < ActiveRecord::Base
  belongs_to :forum
  has_many :messages
  has_one :initial_message, :class_name => 'Message', :order => 'created_at', :dependent => :destroy 
    # initial message is just the first created message with this topic's ID.
    # dependent => destroy ensures that this initial message has to exist in order for the topic to exist.
    # if an initial message is somehow destroyed (which should never happen because the topic should be deleted instead, keeping the message), the topic is as well.
    # replies to a topic are always preserved for posterity.
  has_many :subscriptions, :as => :subscribable
  has_many :subscribers, :through => :subscriptions
    
  accepts_nested_attributes_for :initial_message
  acts_as_readable :on => :updated_at # gem 'unread'
  # FIXME Use a "last_reply_at" column instead of "updated_at". When the title of a topic is changed, the topic is considered unread, for example.
  
  validates_presence_of :title
  
  attr_accessor :user
    
  PerPage = 10
  paginates_per PerPage
  scope :global, where('global = ?', true).order('created_at DESC')
  scope :with_stickies, order('sticky DESC, updated_at DESC')
  
  after_create :notify_forum_subscribers
    def notify_forum_subscribers
      forum.subscribers.each { |subscriber| SubscriptionMailer.delay.forum_activity(subscriber.name, subscriber.email, self, forum) }
    end
    
  def user
    initial_message.user
  end
  
  def body
    initial_message.body
  end
  
  def most_recent_reply
    messages.reorder('created_at DESC').first # reorder works! Awesome. Message has default_scope of created_at, and this is pretty much the only place I'll need to use a different order.
  end
  
  def replies
    messages_count - 1
  end
  
  def last_page
    (messages_count.to_f / Message::PerPage).ceil
  end
end
