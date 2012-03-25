class AboutController < ApplicationController
  before_filter :get_todays_events, :get_current_events, :get_featured_dj, :get_mbj_feed, :get_links, :get_channel_descriptions, :get_management, :get_tags, :get_contact
  
  def history
    @content = StaticContent.find_by_text_id('about_history')
    render 'home/about'
  end
  
  def contact
    @content = StaticContent.find_by_text_id('about_contact')
    render 'home/about'
  end
  
  def channels
    @content = StaticContent.find_by_text_id('about_channels')
    render 'home/about'
  end
  
  def submissions
    @content = StaticContent.find_by_text_id('about_submissions')
    render 'home/about'
  end
end