module TagAccessor
  def tag_tokens
    tags.map(&:name).join(',')
  end
  
  def tag_tokens=(names)
    self.tag_ids = names.split(",").map{|name| Tag.find_or_create_by_name(name.gsub(/[^\w\'\"\- &\/]/, ' ').gsub(/ {2,}/, ' ').strip).id }.uniq
  end
end