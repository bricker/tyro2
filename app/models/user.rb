class User < ActiveRecord::Base
  has_secure_password
  
  #########################
  # Associations
  #########################
  has_and_belongs_to_many :shows
  has_and_belongs_to_many :events
  has_many :completed_training_steps, :dependent => :destroy
  has_many :training_steps, :through => :completed_training_steps
  has_and_belongs_to_many :permissions # for maintenance of various records such as users, shows, etc.
  has_and_belongs_to_many :roles # Mostly for listing purposes. Also handles alumni and noobs.
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :comments_made, :class_name => 'Comment', :inverse_of => :commenter
  has_many :substitutions #an instance of substitution.
  has_many :substitute_shows, :through => :substitutions, :source => :show #the shows for which the DJ is subbing
  has_many :problem_reports
  has_many :strikes, :foreign_key => 'sinner_id', :inverse_of => :sinner, :dependent => :destroy
  has_many :strikings, :class_name => 'Strikes', :foreign_key => 'striker_id', :inverse_of => :striker
  has_many :topics, :through => :messages
  has_many :messages
  has_many :subscriptions, :foreign_key => 'subscriber_id', :dependent => :destroy
  
  # Paperclip
  has_attached_file :avatar,
                    :styles => { :medium => "140x140#", :small => "125x125#", :tiny => "60x60#" },
                    :default_url => "http://thebirn.com/images/defaults/dj_pic_default_:style.jpg",
                    :url => "http://thebirn.com/avatars/user/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/avatars/user/:id/:style/:basename.:extension"
  
  attr_accessor :signup_id, :deleted_bool, :deleted_bool_confirmation, :reset_password
  attr_protected :deleted_bool, :deleted_bool_confirmation, :reset_password
  acts_as_reader # gem 'unread'
  
  attr_reader :show_tokens
  def show_tokens=(ids)
    self.show_ids = ids.split(",")
  end
  
  
  ############################
  # Validations
  ############################
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/jpg', 'image/png']
  validates_attachment_size :avatar, :less_than => 2.megabytes, :message => " file size is too big."
  validates_format_of       :email,         :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_length_of       :about, :maximum => 700,  :on => :update, :message => " - No more than 700 characters please. Thanks.", :allow_nil => true
  validates_length_of       :password,  :within => 5..40, :if => "password.present?"
  validates_confirmation_of :password, :if => "password.present?"
  validates_presence_of     :name, :email
  validates_uniqueness_of   :email, :message => " is already in use."
  validates_confirmation_of :deleted_bool
  validate :has_roles, :on => :update
    def has_roles
      errors.add(:base, "Roles must be assigned") if roles.blank?
    end
  
  # FIXME validate filename (a # causes issues, for example)
  
  #############################
  # Callbacks
  #############################
  before_update   :encrypt_password, :if => "password.present?" 
  
  before_update :set_alumnus, :if => "role_ids.present? and roles.include? Role.find_by_title('alumnus')"
  def set_alumnus
    clear_associations
    self.roles = Role.where(:title => 'alumnus')
  end
  
  before_update :set_dj, :if => "shows.present? and !roles.include? Role.find_by_title('dj')"
  def set_dj
    self.roles << Role.find_by_title('dj')
  end
  
  before_update :do_active, :unless => "deleted_at.present?"
  def do_active
    self.active = roles.any? {|role| %w{noob management}.include?(role.title)} || shows.active.present?
    true # since the above line can return "false", we just need to return true so it doesn't halt the save.
  end
  
  before_create :create_user_information #before_save always runs before #before_create
  def create_user_information # for new users. runs last according to rails.
    self.dj_name = name
    self.roles = Role.where(:title => 'noob')
    self.active = true
    set_password
  end
  
  def set_password
    self.password = create_password
    self.encrypt_password
  end
  
  after_create :send_welcome_email
  def send_welcome_email
    UserMailer.delay.welcome(self, self.password)
  end

  after_create :remove_signup, :if => "signup_id.present?"
  def remove_signup #just removes the signup if it exists
    Signup.find(signup_id).destroy
  end
    
      
  #########################
  # Scopes
  #########################
  scope :living, where('deleted_at IS NULL')
  scope :with_shows, select('DISTINCT users.*').joins(:shows)
  scope :has_role, lambda { |roles| select('DISTINCT users.*').joins(:roles).where('roles.title IN (?)', roles) }
  
  
  ########################
  # Class Methods
  ########################
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_requested_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def self.featured_dj
    has_role('dj').where('users.about IS NOT NULL and active = ?', true).order('RAND()').first
  end
  
  def soft_delete
    save_attr = %w{id created_at name} # attributes that should not be nillified
    attribute_names.reject { |attrib| save_attr.include?(attrib) }.each { |attrib| self[attrib] = nil }
    clear_associations
    self.deleted_at = Time.zone.now
    self.save(:validate => false)
  end
  
  def clear_associations
    [permissions, shows, roles, read_marks, completed_training_steps, strikes, subscriptions].each { |assoc| assoc.clear } # if :dependent => :destroy is set, the records will be destroyed, otherwise the foreign key is nullified.
  end
  
  def set_password_and_send_welcome_email
    set_password
    send_welcome_email if save
  end
  
  #############################
  # Instance Methods
  #############################
  def allowed_to(*args) #TODO: Account for the owner of an object passed in.
    return false if permissions.blank?
    return true if permissions.exists?(:title => "admin")
    args.each do |p|
      return true if permissions.exists?(:title => p)
    end
    return false #just in case
  end
    
    
   ############################ 
   # Authentication and Password
   ############################   
   def self.authenticate(email, password)
     find_by_email(email).try(:authenticate, password)
   end
   
   def generate_password
     consonants = %w(b c d f g h j k l m n p qu r s t v w x z ch cr fr nd ng nk nt ph pr rd sh sl sp st th tr)
     vowels = %w(a e i o u y)
     i, password = true, ''
     8.times do
       password << (i ? consonants[rand * consonants.size] : vowels[rand * vowels.size])
       i = !i
     end
     self.password = password
   end
end
