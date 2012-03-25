class TrainingStep < ActiveRecord::Base
  has_many :completed_training_steps
  has_many :users, :through => :completed_training_steps
  validates_presence_of :title
    
  attr_accessor :position_before
  attr_reader :noob_tokens
  def noob_tokens=(ids)
    self.user_ids = ids.split(",")
  end
  
  default_scope order('position')
  PositionOptions = [["First Step", "-1"]] + all.map{|step| ["After #{step.title}", step.position]}
  
  
  before_create :make_text_id
    def make_text_id
      self.text_id = title.gsub(/\W/, "_").downcase
    end
    
  before_save :set_position, :if => "position_before.present?"
    def set_position
      self.position = position_before.to_i + 1
    end
    
  after_save :do_positions, :if => "position_before.present?"
    def do_positions
      TrainingStep.where('position >= ? AND id != ?', position, id).order('position, updated_at DESC').all.each_with_index do |step, index|
        step.update_attribute('position', position + index + 1)
      end
    end
end
