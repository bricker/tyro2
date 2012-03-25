class SubscriptionMailer < ActionMailer::Base
  default :from => "BIRN Subscriptions <tyro@thebirn.com>"
  
  def forum_activity(user_name, user_email, topic, forum)
    @topic = topic
    @forum = forum
    mail(:to => "#{user_name} <#{user_email}>", :subject => "New Topic in #{forum.subject}")
  end
  
  def topic_activity(user_name, user_email, message, topic)
    @message = message
    @topic = topic
    mail(:to => "#{user_name} <#{user_email}>", :subject => "New Reply to #{topic.title}")
  end
end
