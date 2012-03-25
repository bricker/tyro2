class UserMailer < ActionMailer::Base
  default :from => "The BIRN <tyro@thebirn.com>"
  
  def welcome(user, temporary_password)
    @user = user
    @temporary_password = temporary_password
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Welcome to the BIRN Control Panel")
  end
  
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end
end
