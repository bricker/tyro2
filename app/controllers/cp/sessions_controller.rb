class Cp::SessionsController < Cp::BaseController
  skip_before_filter :login_required
  
  def emails
    @users = User.order('name').select('name, email')
  end
  
  def new
    redirect_to cp_root_path if @current_user
  end
  
  def create
    user = User.authenticate(params[:email], params[:password])
    if user
  	  session[:user_id] = user.id
  	  if session[:return_to]
  	    redirect_to session[:return_to]
  	    session[:return_to] = nil
  	  else
  	    redirect_to cp_root_path
  	  end
  	else
  	  flash.now.alert = "Wrong Login Information. Try again."
  	  render 'new'
  	end
  end

  def destroy
  	session[:user_id] = @current_user = nil
  	redirect_to cp_login_path, :notice => "Logged out."
  end

end