class Signup < ActiveRecord::Base
  validates_presence_of :name, :phone_number, :semester_level, :major, :interest, :preferred_genres, :preferred_slots
  validates_numericality_of :student_id
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_confirmation_of :email_confirmation
  
  attr_accessor :email_confirmation
end
