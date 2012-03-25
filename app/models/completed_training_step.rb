class CompletedTrainingStep < ActiveRecord::Base
  belongs_to :user
  belongs_to :training_step
  
  def self.completed_on(step)
    find_by_training_step_id(step.id).created_at
  end
end
