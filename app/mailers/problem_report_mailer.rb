class ProblemReportMailer < ActionMailer::Base
  include ApplicationHelper
  helper :application
  
  default :from => "BIRN Problem Reports <tyro@thebirn.com>"
  
  def notify(problem_report)
    @problem_report = problem_report
    mail(:to => "webteam@thebirn.com, gm@thebirn.com, review@thebirn.com", :subject => "New Problem Report: #{problem_report.category.humanize}")
  end
end
