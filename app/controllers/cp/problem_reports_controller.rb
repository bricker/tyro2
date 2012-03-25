class Cp::ProblemReportsController < Cp::BaseController
  before_filter :get_problem_report, :only => [:show, :edit, :update, :toggle_status, :destroy]
  before_filter :check_if_can_manage_this_problem_report, :only => [:edit, :update, :destroy]
  before_filter :check_if_can_manage_all_problem_reports, :only => :toggle_status
  
  respond_to :html
  
  def index
    if params[:list] == 'closed'
      @problem_reports = ProblemReport.closed
    elsif params[:list] == 'mine'
      @problem_reports = ProblemReport.mine(@current_user.id).order('closed')
    else
      @problem_reports = ProblemReport.opened
    end
    
    respond_with @problem_reports = @problem_reports.order("created_at " + order).category(category).page(params[:page]).per(10)
  end
  
  def show
    respond_with @problem_report
  end
  
  
  def new
    respond_with @problem_report = ProblemReport.new
  end
  
  def create
    @problem_report = ProblemReport.new(params[:problem_report].merge!(:user_id => @current_user.id))
    flash[:notice] = "Opened New Problem Report" if @problem_report.save
    respond_with :cp, @problem_report
  end
  
  
  def edit
    respond_with @problem_report
  end
  
  def update
    flash[:notice] = "Updated Problem Report" if @problem_report.update_attributes(params[:problem_report])
    respond_with :cp, @problem_report
  end
  
  def toggle_status
    if @problem_report.update_attribute('closed', !@problem_report.closed)
      flash[:notice] = "Changed Status"
    else
      flash[:alert] = "Could not change status"
    end
    redirect_to cp_problem_reports_path
  end
  
  
  def destroy
    if @problem_report.destroy
      flash[:notice] = "Deleted Problem Report"
    else
      flash[:alert] = "Could not delete problem report"
    end
    respond_with :cp, @problem_report
  end
  
  private
    def get_problem_report
      @problem_report = ProblemReport.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Problem Report Not Found"
        redirect_to cp_problem_reports_path
    end
    
    def check_if_can_manage_this_problem_report
      return true if @problem_report.user == @current_user or @current_user.allowed_to('manage_problem_reports')
      redirect_to @problem_report and return false
    end
    
    def check_if_can_manage_all_problem_reports
      return true if @current_user.allowed_to('manage_problem_reports')
      redirect_to cp_problem_reports_path and return false
    end
    
    def order
      %w{asc desc}.include?(params[:order]) ? params[:order] : "desc"
    end 
    
    def category
      ProblemReport::Categories.include?(params[:category]) ? params[:category] : nil
    end
end