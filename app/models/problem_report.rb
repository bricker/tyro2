class ProblemReport < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :as => :commentable
  
  validates_presence_of :category, :title, :description, :user_id
    
  default_scope includes(:user, :comments)
  scope :opened, where('closed = ?', false)
  scope :closed, where('closed = ?', true)
  scope :mine, lambda { |user_id| where("user_id = ?", user_id) }
  scope :category, lambda { |category| where("problem_reports.category = ?", category) unless category.blank? }
  
  after_create :send_notifications
  
  Categories =  ['computer', 'equipment', 'studio_maintenance', 'website', 'security', 'other'] # these should be URL-friendly.
  
  def send_notifications
    ProblemReportMailer.delay.notify(self)
  end
end
