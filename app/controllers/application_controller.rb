class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
    def get_todays_events # get_coming_events
      @todays_events = ScheduleEvent.coming
    end
  
    def get_current_events
      @current_events = ScheduleEvent.current
      #@current_event = @current_events.of_type('Birn1').first
      #@current_event = @current_events.of_type('BirnPresents').first if @current_event.blank?
      #@current_event = @current_events.of_type('Birn2').first if @current_event.blank?
    end
  
    def get_mbj_feed
      require 'rss' # ruby's built-in RSS Parser
      @mbj_items = RSS::Parser.parse(open('http://www.thembj.org/feed/').read, false).items[0..2]
      rescue # if the feed can't be found it throws SocketError. Also possible is a Timeout error. Pass it an empty array so the partial gets something to handle.
        @mbj_items = []
    end
  
    def get_featured_dj
      @featured_dj = User.featured_dj
    end
    
    def get_links
      @links = StaticContent.find_by_text_id('links_box') || ''
    end
    
    def get_contact
      @contact = StaticContent.find_by_text_id('contact_box') || ''
    end
    
    def get_channel_descriptions
      @channel_descriptions = StaticContent.where("text_id LIKE ?", 'header\_text\_%')
      @birn1_text = @channel_descriptions.find {|c| c.text_id == "header_text_birn1"}.content rescue "Birn 1"
      @birn2_text = @channel_descriptions.find {|c| c.text_id == "header_text_birn2"}.content rescue "Birn 2"
      @birn3_text = @channel_descriptions.find {|c| c.text_id == "header_text_birn3"}.content rescue "Birn 3"
      @birn4_text = @channel_descriptions.find {|c| c.text_id == "header_text_birn4"}.content rescue "Birn 4"
      @birn5_text = @channel_descriptions.find {|c| c.text_id == "header_text_birn5"}.content rescue "Birn 5"
      @birn_presents_text = @channel_descriptions.find {|c| c.text_id == "header_text_birn_presents"}.content rescue "Birn Presents"
    end
    
    def get_management
      @management = User.has_role("management")
    end
    
    def get_tags
      @tags = Tag.limit(10)
    end
end
