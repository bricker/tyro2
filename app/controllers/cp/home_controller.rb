class Cp::HomeController < Cp::BaseController
  
  def index
    @latest_topics = Topic.order('updated_at DESC').limit(5)
    @announcements = Topic.global.limit(3)
    @unread_topics = Topic.unread_by(@current_user)
  end
  
  def resources
    @resources = StaticContent.find_by_text_id('resources')
  end
  
  def tin_news
    @tin_news = StaticContent.find_by_text_id('tin_news')
  end
end
