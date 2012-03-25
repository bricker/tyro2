class Strike < ActiveRecord::Base
  belongs_to :sinner, :class_name => 'User', :inverse_of => :strikes
  belongs_to :striker, :class_name => 'User', :inverse_of => :strikings
  
  validates_presence_of :sinner_id, :striker_id, :severity, :reason, :offense_on
  validates_numericality_of :severity
  
  Reasons = ["Missed Meeting", "Missed Show", "Late for Show", "Swear Word", "Unapproved Guest", "Lingering Strike", "No Playlist", "Other"]
  
  default_scope order('created_at DESC')
  scope :resolved, where('resolved = ?', true)
  scope :unresolved, where('resolved = ?', false)
  
  after_save :update_strikes, :if => 'sinner.present?'
  after_destroy :update_strikes, :if => 'sinner.present?'
  
  def update_strikes
    sinner.total_strikes = 0
    sinner.strikes.unresolved.each { |strike| sinner.total_strikes += strike.severity }
    sinner.save
  end
  
end
