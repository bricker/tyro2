class Cp::PasswordResetsController < Cp::BaseController
  skip_before_filter :login_required

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to cp_login_path, :notice => "Password reset instructions sent to #{params[:email]}"
  end
  
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end
  
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_requested_at < 30.minutes.ago
      redirect_to new_cp_password_reset_path, :alert => "Password reset has expired. Request another reset."
    else
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
      if @user.save
        redirect_to cp_login_path, :notice => "Password has been reset."
      else
        render :edit
      end
    end
  end
end
