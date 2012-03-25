class StaticContent < ActiveRecord::Base
  validates_presence_of :text_id, :description
  # could use an attr_protected on :text_id, but I don't think it's that big of a deal.
end
