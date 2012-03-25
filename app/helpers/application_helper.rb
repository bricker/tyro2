module ApplicationHelper
  def no_records_check(record, name, options = {})
    # This simply checks if the record is blank, and displays a message if so. It's here for cross-app consistancy.
    options[:message] ||= "There are no #{name} to list!" if record.blank?
  end
  
  def livecam_icon(cam='broadcast')
    link_to image_tag('icons/webcam.png', :class => 'webcam-icon', :alt => "Live Cam"), livecam_path(:cam => cam), :class => 'webcam', :id => cam
	end
	
	def facebook_uids_string(users)
	  users.uniq.reject{|u| u.facebook_uid.blank?}.map(&:facebook_uid).join(',') 
  end
  
	def display_avatar(record, size = "small", options = {})
	  options[:class] ? options[:class] = "avatar #{size}Av #{options[:class]}" : options.merge!(:class => "avatar #{size}Av") #all avatars should have class 'avatar'
	  image_tag(record.avatar.url(size), options)
	end
	
	def nl2br(text) #"new line to <br>" for text areas. Better to use rails' simple_format, but I'll leave this here.
    text.gsub(/\n/, '<br />') unless text.blank?
  end
  
  def pretty_date(date, options = {})
    time_format = date.strftime("%l:%M%p").downcase
    if options[:short]
      pretty_date = date.strftime("%D")
      pretty_date += " - " unless !options[:time]
    elsif options[:only_time]
      return time_format
    else
      pretty_date = date.strftime("%A, %B ") + date.strftime("%e").to_i.ordinalize + ", " + date.strftime("%Y")
      pretty_date += " at " unless !options[:time]
    end
    pretty_date += time_format unless !options[:time]
    return pretty_date
  end
end
