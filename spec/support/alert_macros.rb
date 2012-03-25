module AlertMacros
  def check_for_flash(type)
    if type == "notice"
      page.find(".notice").should_not be_nil
      page.should_not have_css(".alert")
    elsif type == "alert"
      page.find(".alert").should_not be_nil
      page.should_not have_css(".notice")
    elsif type == "any"
      page.find("#flash_messages").should_not be_nil
    elsif type == "none"
      page.should_not have_css("#flash_messages")
    end
  end
  
  def check_for_validation_errors(*args)
    unless args.first == "none"
      find("#error_explanation").should_not be_nil
      args.each do |error|
        find("#error_explanation").should have_content(error)
      end
    else
      page.should_not have_css("#error_explanation")
    end
  end   
end