if %w{production staging}.include? Rails.env
  ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => 'mail.thebirn.com',
    :user_name            => 'tyro2@thebirn.com',
    :password             => Secrets["email_password"],
    :authentication       => 'plain',
    :enable_starttls_auto => true  
  }
end
