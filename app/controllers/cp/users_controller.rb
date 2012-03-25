class Cp::UsersController < Cp::BaseController
  before_filter :get_user, :except => [:index, :search, :index_inactive, :new, :create, :new_multiple, :create_multiple] # required to populate @user
  before_filter :check_if_can_manage_user_info, :only => [:edit, :update] # MGs only in this controller, except for the "show" action
  before_filter :check_if_can_manage_users_full, :only => [:edit_remove, :remove, :new, :create, :new_multiple, :create_multiple, :edit_user_password, :update_user_password, :resend_welcome] # Higher-up MGs can do these things
  before_filter :check_if_can_admin, :only => [:edit_permissions, :update_permissions]
  before_filter :get_roles, :only => [:manage, :update_manage]
  
  respond_to :html, :json, :js
  
  # TODO: jQuery search field
  # TODO: Helper to display user name... link unless soft-deleted.
  
  def index
    if params[:filter] == 'inactive' # this whole thing could be better.
      @users = User.where(:active => false).includes(:roles)
    elsif params[:filter] == 'management'
      @users = User.has_role('management')
    elsif params[:filter] == 'noobs'
      @users = User.has_role('noob')
    elsif params[:filter] == 'active_djs'
      @users = User.has_role('dj').where(:active => true)
    elsif params[:filter] == 'alumni'
      @users = User.has_role('alumnus')
    else
      @users = User.where(:active => true)
    end    
    
    if @current_user.allowed_to('manage_strikes')
      if params[:order] == 'strikes'
        @users = @users.order('total_strikes DESC')
      end
    end
    @users = @users.living.order('name').includes(:roles)
    respond_with @users
  end
  
  def search
    @users = User.living.where("name like ?", "%#{params[:q]}%")
    @users = @users.has_role(params[:role]) if params[:role].present?
    respond_to do |format|
      format.json { render :json => @users.map { |u| { :id => u.id, :name => u.name } } }
    end
  end
    
  def show
    respond_with @user
  end
  
  def comments
    if (@current_user != @user and @current_user.allowed_to('train_users', 'manage_users_full', 'manage_strikes')) or @current_user.allowed_to('admin')
      respond_with @user.comments
    else
      redirect_to cp_user_path(@user) and return false
    end
  end
    
  
  def new
    respond_with(@user = User.new)
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Added #{@user.name} and sent a welcome e-mail." unless params[:user][:signup_id].present? # don't need the flash since we're doing it with AJAX on signups
    end
    respond_with(:cp, @user)
  end
  
  def resend_welcome
    if @user.set_password_and_send_welcome_email
      flash[:notice] = "Reset password and resent welcome e-mail to #{@user.name}"
    else
      flash[:error] = "There was a problem resending the e-mail."
    end
    respond_with(:cp, @user)
  end
  
  
  def new_mutliple
  end
  
  def create_multiple # move to model
    successes = []
    failures = []
    params[:name_email_pairs].scan(/\s?(.+?)\s*?<(.+?)>,?/).each do |user|
      @user = User.new(:name => user[0], :email => user[1])
      @user.save ? successes << @user : failures << [@user, @user.errors]
    end
    
    flash[:notice] = "Added #{successes.length} new user#{ 's' unless successes.length == 1}." unless successes.empty?
    unless failures.empty?
      flash[:alert] = "Failed to add #{failures.length} user#{ 's' unless failures.length == 1}: <br />".html_safe
      failures.each { |failure| flash[:alert] += "#{failure[0].name} / #{failure[0].email} (#{failure[1].full_messages.join(', ')})<br />".html_safe }
    end
    redirect_to cp_users_path
  end
  
  
  def edit
    respond_with @user
  end
  
  def update    
    flash[:notice] = "Updating Profile. Please check back in a moment." if @user.update_attributes(params[:user])
	  respond_with(:cp, @user)
  end
  
  
  def edit_password
    respond_with @user
  end
  
  def update_password
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    
   if @user.save
     flash[:notice] = "Password Changed"
     respond_with :cp, @user
   else
     render :edit_password
   end
  end
  
  
  def manage # for vital info such as name and role
    respond_with @user
  end
  
  def update_manage
    params[:user][:role_ids] ||= []
    if @user.update_attributes(params[:user])
      flash[:notice] = "Updated User" 
      respond_with(:cp, @user)
    else
      render :manage
    end
  end
  
  
  def edit_remove
    respond_with @user
  end
  
  def remove
    if params[:user][:deleted_bool] == "1" and params[:user][:deleted_bool_confirmation] == "1"
      @user.deleted_bool = params[:user][:deleted_bool] == "1"
      @user.deleted_bool_confirmation = params[:user][:deleted_bool_confirmation] == "1"
      if @user.update_attribute(:deleted_at, Time.zone.now)
        @user.delay.soft_delete
        redirect_to cp_users_path, :notice => "Removed #{@user.name}."
      end
    else
      flash[:alert] = "Did not remove user"
      respond_with [:cp, @user], :location => edit_remove_cp_user_path(@user)
    end
  end
  
  
  def edit_permissions
    @permissions = Permission.all
    respond_with @user
  end
  
  def update_permissions
    params[:user][:permission_ids] ||= []
    flash[:notice] = "User Permissions Updated." if @user.update_attributes(params[:user])
    respond_with(:cp, @user)
  end
  
  private
    def get_user
      @user = User.living.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to cp_users_path, :alert => "User not found."
    end
   
    def check_if_can_manage_user_info
      return true if @current_user.allowed_to('manage_user_info', 'manage_users_full')
      redirect_to cp_root_path and return false
    end
    
    def check_if_can_manage_users_full
      return true if @current_user.allowed_to('manage_users_full')
      redirect_to cp_root_path and return false
    end
    
    def check_if_can_admin
      return true if @current_user.allowed_to('admin')
      redirect_to cp_root_path and return false
    end
    
    def get_roles
      @roles = Role.all
    end
end