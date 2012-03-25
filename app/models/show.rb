class Show < ActiveRecord::Base
  has_many :posts, :dependent => :destroy
  has_many :schedule_events, :as => :schedulable, :dependent => :destroy
  has_and_belongs_to_many :users
  
  has_many :taggings, :as => :taggable, :dependent => :destroy
  has_many :tags, :through => :taggings, :uniq => true
  include TagAccessor # tag_tokens setter and getter. found in /lib folder.
  
  has_attached_file :avatar,
                    :styles => {  :medium => "140x", :tiny => "70x" },
                    :default_url => "http://thebirn.com/images/defaults/show_pic_default_:style.jpg",
                    :url => "http://thebirn.com/avatars/show/:id/:style/:basename.:extension", # absolute URL so avatars show in development
                    :path => ":rails_root/public/avatars/show/:id/:style/:basename.:extension"
                    
  define_index do
    indexes title
    indexes description
    indexes tags(:name), :as => :tags
    
    has active
  end
  
  accepts_nested_attributes_for :schedule_events
  
  before_validation :make_slug, :on => :create
    def make_slug
      self.url_slug = self.title.parameterize
    end
    
  validates_uniqueness_of :url_slug
  validates_presence_of :title

  before_save :do_active
    def do_active
      self.active = schedule_events.future.present? && users.present?
      true # since the above line can return "false", we just need to return true so it doesn't halt the save.
    end
    
  after_save :set_djs, :if => "user_ids.present?"
    def set_djs
      dj_role = Role.find_by_title('dj')
      users.each { |user| user.roles << dj_role unless user.roles.include? dj_role }
    end
    
  after_save :save_users # Sets "Active" status for these users.
    def save_users
      users.each do |user| 
        user.updated_at = Time.zone.now
        user.save
      end
    end
    
  attr_reader :user_tokens
  def user_tokens=(ids)
    self.user_ids = ids.split(",")
  end
  
  # Scopes
  default_scope where('deleted_at IS NULL').order("title") # The REPLACE MySql function breaks the search if a show is just named "The "
  scope :active, where("active = ?", true)
  scope :inactive, where("active = ?", false)
   
  def to_param
    "#{id}-#{url_slug}" # this creates urls like /shows/65-thisisnow when using URL helpers
  end
  
  def next
    schedule_events.order('starts_at').where('starts_at > ?', Time.zone.now).first
  end
end
