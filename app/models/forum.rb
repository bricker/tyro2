class Forum < ActiveRecord::Base
  has_many :topics
  has_many :subscriptions, :as => :subscribable
  has_many :subscribers, :through => :subscriptions

  validates_presence_of :subject
  attr_accessor :position_before
  
  default_scope order('position')
  PositionOptions = [["First Forum", "-1"]] + all.map{|forum| ["After #{forum.subject}", forum.position]}
  
  def most_recently_active_topic
    topics.order('updated_at DESC').first
  end
  
  before_save :set_position, :if => "position_before.present?"
    def set_position
      self.position = position_before.to_i + 1
    end
    
  after_save :do_positions, :if => "position_before.present?"
    def do_positions
      Forum.where('position >= ? AND id != ?', position, id).order('position, updated_at DESC').all.each_with_index do |forum, index|
        forum.update_attribute('position', position + index + 1)
      end
    end
    
end
