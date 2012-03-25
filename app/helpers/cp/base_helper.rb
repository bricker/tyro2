module Cp::BaseHelper
  def check_for_errors(object)
    render(:partial => 'cp/shared/form_errors', :locals => { :object => object }) if object.errors.any?
  end
  
  def pending_icon(event)
    image_tag("icons/clock.png", :class => 'clock-icon') if !event.published
  end 
  
  def datepicker_display(date, options={})
    return nil if date.blank?
    if options[:part] == 'time'
      date ? date.strftime("%I:%M %p") : nil
    else
      date ? date.strftime("%m/%d/%Y") : nil
    end
  end
  
  def block_to_partial(partial_name, options = {}, &block)
    options.merge!(:body => capture(&block))
    render(:partial => partial_name, :locals => options)
  end
  
  def box_wrapper(title = nil, options = {}, &block)
    options[:no_tabs] ||= false
    block_to_partial('/cp/shared/box_wrapper', options.merge(:title => title), &block)
  end
  
  def forum_header(crumbs = {}, &block)
    block_to_partial('/cp/forums/header', crumbs, &block)
  end
  
  def reply_box(&block)
    block_to_partial('/cp/messages/reply_box', {}, &block)
  end
  
  def forum_nav(crumbs = {})
    s = " &raquo; ".html_safe
    nav = link_to("Forum", cp_forums_path).html_safe
    
    if crumbs[:forum]
      nav += s + link_to(crumbs[:forum][:subject], cp_forum_topics_path(crumbs[:forum])).html_safe
      nav += s + link_to(crumbs[:topic][:title], cp_topic_messages_path(crumbs[:topic])).html_safe if crumbs[:topic]
    end #forum
    
    nav += s + crumbs[:title].html_safe if crumbs[:title]
    nav.html_safe
  end
  
  def nav(partial, *active_tabs)
    partial = "#{params[:controller]}/nav_partials/#{partial}" unless partial.chars.first == '/'
    render :partial => partial, :locals => { :active_tabs => active_tabs }
  end
  
  def nav_link(title, path, active, options = {})
    if active
      options[:class] ? options[:class] += " active" : options[:class] = "active"
    end
    link_to(title, path, options)
  end
  
  def display_message(message, options = {}) # OPTIMIZE Smilies & Tyro Code need to be cleaned up between view, JS, and helper.  
    unless options[:tyro_code] == false
    
    #   codeTags = { #doesn't quite work
    #               /\[b\](.+?)\[\/b\]/m => ["<strong>", "</strong>"],
    #               /\[i\](.+?)\[\/i\]/m => ["<em>", "</em>"]
    #               #/\[quote who ?= ?["|']?(.+?)["|']?\](.+?)\[\/quote\]/m => "<div class=\'quote\'><div class='who'>\\1</div>: <p>\\2</p> </div>"
    #              }
    #              
    #              regexp = Regexp.new(/(#{Regexp.union(codeTags.keys)})/)
    #              message = (message).gsub(regexp) do |match|
    #                code_element = codeTags[codeTags.keys.select {|k| match =~ k}[0]]
    #                "#{code_element[0]}#{$1}#{code_element[1]}"
    #              end


       # tyro_code: quote: [quote][/quote]
       message.gsub!(/\[quote who=(.+?)\](.+?)\[\/quote\]/m, "<div class=\"body-quote\"><strong>\\1</strong>: \\2</div>")
         # quick lesson on this regex:
         # basically finding [quote](anything with > 1 character)[/quote]
         # then replacing that with the second gsub argument
         # where \\1 is the text in parenthases from the first argument
         # In single quotes, use only one backslash \1
         
       # tyro_code: link: [link url=""][/link]
         message.gsub!(/\[link url ?= ?["|']?(.+?)["|']?\](.+?)\[\/link\]/m, "<a href=\"\\1\" target=\"_blank\">\\2</a>")
     
       # tyro_code: link: [link][/link]
         message.gsub!(/\[link\](.+?)\[\/link\]/m, "<a href=\"\\1\" target=\"_blank\">\\1</a>")
           
       #tyro_code: bold: [b][/b]
         message.gsub!(/\[b\](.+?)\[\/b\]/m, "<strong>\\1</strong>")
 
       # tyro_code: italic: [i][/i]
         message.gsub!(/\[i\](.+?)\[\/i\]/m, "<em>\\1</em>")
 
       # tyro_code: underline: [u][/u]
         message.gsub!(/\[u\](.+?)\[\/u\]/m, "<span class='underline'>\\1</span>")
 
       # tyro_code: font color: [color=""][/color]
         message.gsub!(/\[color ?= ?["|']?(.+?)["|']?\](.+?)\[\/color\]/m, "<span style='color:\\1'>\\2</span>")
 
       # tyro_code: font size: [size=""][/size]
         message.gsub!(/\[size ?= ?["|']?(.+?)["|']?\](.+?)\[\/size\]/m, "<span style='font-size:\\1px'>\\2</span>")
 
       # tyro_code: images: [image][/image]
         message.gsub!(/\[image\](.+?)\[\/image\]/, "<img src='\\1' alt=''/>")
         
         # URLS > link, needs to be after image.
           message = auto_link(message, :sanitize => false)
    end
    
    ## smilies
    unless options[:smilies] == false
      smilies = {
                /:-?\)/ => "happy.png",
                /:-?\(/ => "sad.png",
                />:-?(\(|o)/i => "angry.png", 
                /:-?P/i => "tongue.png",
                /;-?\)/ => "wink.png", 
                /:-?D/ => "grin.png", 
                /8-\)/ => "cool.png", 
                /:-?\[/ => "blush.png", 
                /:roll:/i => "icon_rolleyes.gif", 
                /:-?\|/ => "icon_neutral.gif", 
                /:-\// => "undecided.png"
                }
        regexp = Regexp.new(/(#{Regexp.union(smilies.keys)})/)
        message = (message).gsub(/#{regexp}/) do |match|
          image_tag("smilies/"+smilies[smilies.keys.select {|k| match =~ Regexp.new(k)}[0]], :alt => match, :class => 'smiley')
        end
      end
    
    return simple_format(message, {}, :sanitize => false).html_safe
  end
    
#  # tyro_code: quote: [quote][/quote]
#  message.gsub(/\[quote who ?= ?["|']?(.+?)["|']?\](.+?)\[\/quote\]/m, "<div class=\"forum-quote\"><u>\\1</u>: \\2 </div>")
#    # quick lesson on this regex:
#    # basically finding [quote](anything with > 1 character)[/quote]
#    # then replacing that with the second gsub argument
#    # where \\1 is the text in parenthases from the first argument
#    # In single quotes, use only one backslash \1
#
#  # tyro_code: link: [link url=""][/link]
#    message.gsub!(/\[link url ?= ?["|']?(.+?)["|']?\](.+?)\[\/link\]/m, "<a href=\"\\1\" target=\"_blank\">\\2</a>")
#    
#  # tyro_code: link: [link][/link]
#    message.gsub!(/\[link\](.+?)\[\/link\]/m, "<a href=\"\\1\" target=\"_blank\">\\1</a>")
#
#  #tyro_code: bold: [b][/b]
#    message.gsub!(/\[b\](.+?)\[\/b\]/m, "<strong>\\1</strong>")
#
#  # tyro_code: italic: [i][/i]
#    message.gsub!(/\[i\](.+?)\[\/i\]/m, "<em>\\1</em>")
#
#  # tyro_code: underline: [u][/u]
#    message.gsub!(/\[u\](.+?)\[\/u\]/m, "<span style='text-decoration: underline;'>\\1</span>")
#
#  # tyro_code: font color: [color=""][/color]
#    message.gsub!(/\[color ?= ?["|']?(.+?)["|']?\](.+?)\[\/color\]/m, "<font color=\"\\1\">\\2</font>")
#
#  # tyro_code: font size: [size=""][/size]
#    message.gsub!(/\[size ?= ?["|']?(.+?)["|']?\](.+?)\[\/size\]/m, "<font size=\"\\1\">\\2</font>")
#
#  # tyro_code: images: [image][/image]
#    message.gsub!(/\[image\](.+?)\[\/image\]/, "<img src=\"\\1\" />")
#         
#    
#  # URLS > link
#    #message.gsub!(/http:\/\/(.+?) /i, "<a href=\"http:\/\/\\1\">http:\/\/\\1<\/a>")
#    
#  # turn new lines into BR tags.
#    message.gsub!(/\n/, "<br />")
#end
  
  def add_button(name, path)
    content_tag :div, :id => 'content-header' do
      link_to name, path, :id => 'add-button'
    end
  end
  	
end
