class GuestRequestMailer < ActionMailer::Base
  helper :application
  
  default :from => "BIRN Guest Requests <tyro@thebirn.com>"
  
  def mail_request(user, params)
    @params = params
    @user = user
    @show = Show.find(params[:show])
    mail(:to => "gm@thebirn.com, review@thebirn.com", :subject => "New Guest Request for: #{params[:show]}")
  end
end
